import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WelcomePageController extends GetxController {
  TextEditingController guestEmailController = TextEditingController();
  TextEditingController guestPasswordController = TextEditingController();

  Future<void> guestLogin() async {
    await AuthController.to.signInWithGuest(
      guestEmailController.text,
      guestPasswordController.text,
    );
    Get.back();
  }

  Future<String> getVersionInfo() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
