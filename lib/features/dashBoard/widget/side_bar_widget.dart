import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/text_styles.dart';
import '../../../components/custom_text_form_field.dart';
import '../provider/SpeakProvider.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  late FocusNode focusNode;
  late FocusNode rawKeyboardListenerNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    rawKeyboardListenerNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      Provider.of<SpeakProvider>(context, listen: false).resetData();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    rawKeyboardListenerNode.dispose();
    super.dispose();
  }

  bool _keyBoardCallback(KeyEvent event) {
    final character = event.character;
    if (character != null && character.contains(RegExp(r'[0-9]'))) {
      int number = int.parse(character);
      Provider.of<SpeakProvider>(context, listen: false)
          .updateOrderNumber(number);
      print(number);
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      Provider.of<SpeakProvider>(context, listen: false).speak();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeakProvider>(builder: (context, provider, _) {
      return BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade500.withOpacity(0.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                      child: Text(
                        "رقم الطلب",
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 15,
                          color: ColorResources.WHITE_COLOR,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      controller: provider.textEditingController,
                      read: true,
                      inputType: TextInputType.number,
                      formatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardAction: TextInputAction.go,
                      focus: focusNode, // Use the initialized focusNode here
                      onSaved: (xc) async {
                        provider.updateOrderNumber(
                          int.parse(provider.textEditingController.text.trim()),
                        );
                        // provider.speak();
                      },
                    ),
                    IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.speaker,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        provider.updateOrderNumber(
                          int.parse(provider.textEditingController.text.trim()),
                        );
                        // provider.speak();
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.orderStrings.length < 20
                            ? provider.orderStrings.length
                            : 0,
                        itemBuilder: (context, index) {
                          final orderList = provider.orderStrings;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(10, 10.h, 10, 1.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade500.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(10, 30.h, 10, 24.h),
                                child: Text(
                                  orderList[orderList.length - 1 - index],
                                  style: AppTextStyles.w600.copyWith(
                                    fontSize: 20,
                                    color: ColorResources.WHITE_COLOR,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
