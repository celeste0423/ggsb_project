import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/root.dart';
import 'package:ggsb_project/src/theme/base_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

void main() async {
  //파이어베이스 설정
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //화면 회전 불가
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
    // SystemChrome.setSystemUIOverlayStyle(
    //   //상단바 테마
    //   SystemUiOverlayStyle.dark.copyWith(
    //     statusBarIconBrightness: Brightness.dark,
    //     statusBarColor: Colors.transparent,
    //     systemStatusBarContrastEnforced: true,
    //     systemNavigationBarColor: Colors.transparent,
    //     systemNavigationBarDividerColor: Colors.transparent,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    // );
  });
  //날짜 언어 세팅
  initializeDateFormatting('ko-KR');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      initialBinding: InitBinding(),
      title: 'GongGeomSeungBu',
      theme: baseTheme(context),
      home: Root(),
    );
  }
}
