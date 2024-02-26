import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingIndicator() {
  return LoadingAnimationWidget.fourRotatingDots(
    color: CustomColors.mainBlue,
    size: 50,
  );
}
