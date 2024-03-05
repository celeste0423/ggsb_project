import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/features/overlay/pages/overlay_page.dart';
import 'package:ggsb_project/src/helpers/google_analytics.dart';
import 'package:ggsb_project/src/root.dart';
import 'package:ggsb_project/src/theme/base_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'src/helpers/amplitude_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //파이어베이스 설정
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //알림 설정
  await _initNotificationSetting();
  //날짜 언어 세팅
  initializeDateFormatting('ko-KR');
  //.env init
  await dotenv.load(fileName: ".env");
  //광고 init
  MobileAds.instance.initialize();
  //firebase analytics init
  GoogleAnalytics().init();
  //Amplitude analytics 설정
  AmplitudeAnalytics().init();
  //새벽 4시에 초기화
  // Cron().schedule(Schedule.parse('01 04 * * *'), () async {
  //   print("새벽 4시입니다.");
  //   if (!AuthController.to.user.value.isTimer!) {
  //     AuthController.to.loginUser(AuthController.to.user.value.uid!);
  //   }
  // });
  //화면 회전 불가
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

Future<void> _initNotificationSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //안드로이드 초기 세팅
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  //ios 초기 세팅
  const DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  //notification 초기 세팅
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

//overlay 진입점
@pragma('vm:entry-point')
void overlayMain() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayPage(),
    ),
  );
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
      home: const Root(),
    );
  }
}
