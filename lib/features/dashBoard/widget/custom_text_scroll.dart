import 'package:flutter/material.dart';
import 'package:live/features/dashBoard/provider/files_provider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../app/core/utils/color_resources.dart';

class CustomTextScroll extends StatelessWidget {
  const CustomTextScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
      builder: (context, provider, _) {
        return TextScroll(
          provider.lastNews ?? "",
          mode: TextScrollMode.endless,
          velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
          delayBefore: Duration(milliseconds: 6000),
          numberOfReps: 15899889521,
          pauseBetween: Duration(milliseconds: 50),
          style: TextStyle(
              color: ColorResources.PRIMARY_COLOR, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
          selectable: true,
        );
      },
    );
  }
}
