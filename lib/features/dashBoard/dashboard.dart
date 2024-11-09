import 'dart:async';
import 'package:code_scan_listener/code_scan_listener.dart';
import 'package:flutter/material.dart';
import 'package:live/features/dashBoard/provider/SpeakProvider.dart';
import 'package:live/features/dashBoard/provider/files_provider.dart';
import 'package:live/features/dashBoard/widget/custom_floating_action_button.dart';
import 'package:live/features/dashBoard/widget/custom_order_screen_body.dart';
import 'package:live/features/dashBoard/widget/custom_refresh_widget.dart';
import 'package:live/features/dashBoard/widget/custom_text_scroll.dart';
import 'package:live/features/dashBoard/widget/side_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../data/network/netwok_info.dart';
import '../../data/signalR/signalr_client.dart';
import '../auth/select_branch_screen/provider/auth_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({this.index, Key? key}) : super(key: key);
  final int? index;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late bool visible = true;
  TextEditingController textEditingController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      SignalrClient().startConnection();
      Provider.of<MediaProvider>(context, listen: false).getFilesByScreenID();
      Provider.of<AuthProvider>(context, listen: false).getTentStatusTimer();
    });
    NetworkInfo.checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(
        child: SideBarWidget(),
      ),
      body: SizedBox(
        key: const Key('visible-detector-key'),
        child: CodeScanListener(
          bufferDuration: const Duration(milliseconds: 200),
          onBarcodeScanned: (barcode) {
            if (!visible) return;
            debugPrint(barcode);
            Timer.periodic(Duration(milliseconds: 100), (Timer t) async {
              if (t.tick < 5) {
                Provider.of<SpeakProvider>(context, listen: false)
                    .updateOrderNumber(t.tick);
                // Provider.of<SpeakProvider>(context, listen: false).speak();
              }
            });

            final data = barcode.replaceAll(new RegExp(r'[^0-9]'), '');
            if (int.tryParse(data) != null) {
              print(data);
              Provider.of<SpeakProvider>(context, listen: false)
                  .updateOrderNumber(int.parse(data));
              // Provider.of<SpeakProvider>(context, listen: false).speak();
            }
          },
          child: Row(
            children: [
              if (Provider.of<MediaProvider>(context, listen: false)
                      .getShowOrderScreen() ??
                  true)
                const Expanded(flex: 1, child: const SideBarWidget()),
              Expanded(
                flex: 3,
                child: Consumer<MediaProvider>(builder: (context, provider, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            Provider.of<MediaProvider>(context, listen: false)
                                .getFilesByScreenID();
                          },
                          child: provider.isLoadingScreen
                              ? const CustomRefreshWidget()
                              // : const CustomOrderScreenBody(),
                              : Center(child: Container(child: Text("Test"))),
                        ),
                      ),
                      const CustomTextScroll()
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
    );
  }
}
