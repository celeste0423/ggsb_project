import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeAnalytics {
  static Amplitude analytics = Amplitude.getInstance(instanceName: "gonggeom");

  Future<void> init() async {
    analytics.init(dotenv.env['AMPLITUDE_SECRET_API_KEY'] ?? '');
  }

  Future<void> logEvent(
      String name,
      Map<String, dynamic>? parameters,
      ) async {
    await analytics.logEvent(name, eventProperties: parameters);
    // print('로그 이벤트 보냄');
  }
}
