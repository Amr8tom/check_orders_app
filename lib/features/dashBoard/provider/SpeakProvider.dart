import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:live/app/core/utils/json_arabic_transalations.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/text_styles.dart';
import '../../../navigation/custom_navigation.dart';
import '../repo/fiels_repo.dart';

class SpeakProvider extends ChangeNotifier {
  final MediaRepo mediaRepo;
  SpeakProvider({required this.mediaRepo}) {
    _initialize();
  }

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();
  final finishSpeak = StreamController<int>.broadcast();
  final FocusNode focusTextField = FocusNode();

  late VideoPlayerController _controller;
  List<String> orderStrings = [];
  // List<int> orderNumberList = [];
  List<int> orderNumber = [];

  bool _isOpen = false;
  bool isTtsFinished = true;
  int cachedNumber = 0;

  Timer? checkerTimer;
  // Timer? _timer;
  Timer? popUpFuture;

  void setMaxVolume() {
    VolumeController()
        .setVolume(1.0); // Set to max volume (range is 0.0 to 1.0)
  }

  // Initialization
  void _initialize() {
    setMaxVolume();
    focusTextField.requestFocus();
    initTts();
    finishSpeak.stream.listen((v) => _handleSpeakCompletion(v));
  }

  Future<void> initTts() async {
    log("Initializing Arabic TTS with enhanced settings...");

    // Use high-quality speech synthesis
    await flutterTts.setVoice({"name": "ar-xa-x-ard-local", "locale": "ar-SA"});
    // await flutterTts.setLanguage("ar-SA");
    await flutterTts.awaitSpeakCompletion(true);
    // await flutterTts.setVolume(1.0);
    // await flutterTts.setSpeechRate(0.45);
    // await flutterTts.setPitch(1.0);

    if (Platform.isIOS) {
      await flutterTts.setSharedInstance(true);
    } else if (Platform.isAndroid) {
      // await flutterTts.setQueueMode(1);
    }

    log("Arabic TTS initialized with enhanced settings.");
  }

  void _handleSpeakCompletion(int v) {
    if (v == 1) {
      CustomNavigator.pop();
      _isOpen = false;
      orderNumber.clear();

      if (!_controller.value.isPlaying) {
        _controller.play();
      }
    }
  }

  // Public Methods
  void getVideoPlayerController(VideoPlayerController controller) {
    _controller = controller;
  }

  void resetData() {
    orderStrings.clear();
    orderNumber.clear();
    cachedNumber = 0;
    notifyListeners();
  }

  Future<void> ttsSpeak(int orderNum) async {
    // orderNumber = convertNumberToArabic(orderNum);
    final orderNums = convertNumberToArabic(orderNum);
    final text = "الطلب رقم ${(orderNums)} جاهز للتسليم";
    flutterTts.setStartHandler(() {
      log("TTS Start");
      isTtsFinished = false;
    });
    flutterTts.setCompletionHandler(() {
      isTtsFinished = true;
      finishSpeak.sink.add(1);
      log("TTS Completion");
    });

    await flutterTts.speak(text);
  }

  void speak() {
    checkerTimer?.cancel();
    checkerTimer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (!_isOpen) {
        for (var orderNum in orderNumber) {
          await Future.delayed(Duration(milliseconds: 15));
          _showOrderDialog(orderNum);
          await ttsSpeak(orderNum);
          textEditingController.clear();
          await storeOrder(orderNum);
          orderStrings.add("الطلب رقم ${orderNum} جاهز للتسليم");
        }
      }
    });
    notifyListeners();
  }

  Future<void> storeOrder(int id) async {
    try {
      notifyListeners();
      await mediaRepo.storeDoneOrder(id);
    } catch (e) {
      log("Error storing order: $e");
    }
  }

  // Order Number Management
  void updateOrderNumber(int digit) {
    orderNumber.add(digit);
    // textEditingController.text = orderNumber.join();
    speak();
    notifyListeners();
  }

  void updateOrderNumberBarcode(int digit) {
    updateOrderNumber(digit);
    // speak();
  }

  // void nextNumber() {
  //   updateOrderNumber(++cachedNumber);
  //   speak();
  // }

  // void previousNumber() {
  //   if (cachedNumber > 0) {
  //     updateOrderNumber(--cachedNumber);
  //     speak();
  //   }
  // }

  // Dialog Management
  Future<void> _showOrderDialog(int orderNum) async {
    _isOpen = true;
    popUpFuture?.cancel();
    orderNumber.remove(orderNum);
    notifyListeners();

    await showDialog(
        context: CustomNavigator.navigatorState.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              height: 500.h,
              width: 250.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("الطلب رقم",
                        style: AppTextStyles.w600
                            .copyWith(fontSize: 35, color: Colors.black)),
                    Text(orderNum.toString(),
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 55, color: ColorResources.PRIMARY_COLOR)),
                  ],
                ),
              ),
            ),
          );
        }).then((_) {
      _isOpen = false;
      orderNumber.clear();
      notifyListeners();
      // _timer?.cancel();
    });
  }
}
