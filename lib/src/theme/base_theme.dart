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
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: 75,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
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
    //checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          // 체크 안한 상태일 때
          if (states.contains(MaterialState.selected)) {
            return CustomColors.mainBlue; // 체크박스 채우기 색상
          } else {
            return Colors.white; // 테두리 색상
          }
        },
      ),
      checkColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          // 체크한 상태일 때
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // 체크 모양 색상
          } else {
            return Colors.white;
          }
        },
      ),
    ),
  );
  return base;
}
