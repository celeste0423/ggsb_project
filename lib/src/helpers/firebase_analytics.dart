import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(
    String name,
    Map<String, dynamic>? parameters,
  ) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters,
    );
    // print('로그 이벤트 보냄');
  }

  Future<void> logAppOpen() async {
    await analytics.logAppOpen();
  }
}
