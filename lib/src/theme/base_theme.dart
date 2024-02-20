import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

ThemeData baseTheme(BuildContext context) {
  final ThemeData base = ThemeData(
    fontFamily: 'nanum',
    primarySwatch: CustomColors.mainBlueMaterial,
    brightness: Brightness.light,
    //배경 색
    scaffoldBackgroundColor: CustomColors.whiteBackground,
    //appbar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: 75,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarIconBrightness: Brightness.dark,
      //   statusBarColor: Colors.transparent,
      //   systemStatusBarContrastEnforced: true,
      //   systemNavigationBarColor: Colors.white,
      //   systemNavigationBarDividerColor: Colors.transparent,
      //   systemNavigationBarIconBrightness: Brightness.dark,
      // ),
    ),
    //textStyle
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'nanum',
          bodyColor: CustomColors.mainBlack,
          displayColor: CustomColors.mainBlack,
        ),
    popupMenuTheme: const PopupMenuThemeData(
      surfaceTintColor: CustomColors.whiteBackground, // 원하는 배경 색으로 변경
    ),
    //dialog
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    //radio
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all<Color>(CustomColors.mainBlue),
    ),
  );
  return base;
}
