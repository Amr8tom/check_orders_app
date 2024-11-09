import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../app/core/utils/color_resources.dart';

class CustomRefreshWidget extends StatelessWidget {
  const CustomRefreshWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        size: 50,
        color: ColorResources.PRIMARY_COLOR,
      ),
    );
  }
}
