import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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
  //crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // This is for catching errors, including normal-level errors
    // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  //Errors outside of Flutter(aspect of context)
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);

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
