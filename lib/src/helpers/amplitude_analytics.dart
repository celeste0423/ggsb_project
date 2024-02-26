import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeAnalytics {
  static Amplitude analytics = Amplitude.getInstance(instanceName: "gonggeom");

  Future<void> init() async {
    // Initialize SDK
    analytics.init(dotenv.env['AMPLITUDE_SECRET_API_KEY'] ?? '');
    analytics.logEvent('Sign Up');
  }
}
