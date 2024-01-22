import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData(fontFamily: 'nanum');
  return base.copyWith(
    brightness: Brightness.light,
    //배경 색
    scaffoldBackgroundColor: CustomColors.whiteBackground,
    //폰트
  );
}
