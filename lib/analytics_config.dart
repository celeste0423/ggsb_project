import 'package:amplitude_flutter/amplitude.dart';

class Analytics_config {
  static late Amplitude analytics =
  Amplitude.getInstance(instanceName: "gonggeom");

  Future<void> init() async {

    // Initialize SDK
    analytics.init('AMPLITUDE_SECRET_API_KEY');
    analytics.logEvent('Sign Up');

  }
}