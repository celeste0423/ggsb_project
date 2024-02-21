import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class StorePageController extends GetxController
    with GetTickerProviderStateMixin {
  static StorePageController get to => Get.find();

  late TabController categoryTabController;

  Map<String, String> unitId = kReleaseMode
      ? {
          'ios': dotenv.env['IOS_AD_UNIT_ID'] ?? '',
          'android': dotenv.env['ANDROID_AD_UNIT_ID'] ?? '',
        }
      : {
          'ios': 'ca-app-pub-3940256099942544/2934735716',
          'android': 'ca-app-pub-3940256099942544/6300978111',
        };

  @override
  void onInit() async {
    super.onInit();
    categoryTabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
