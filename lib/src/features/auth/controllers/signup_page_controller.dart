import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/app.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';

class SignupPageController extends GetxController {
  Rx<String> uid = ''.obs;
  Rx<String> email = ''.obs;

  Rx<bool> isSignupLoading = false.obs;

  TextEditingController nicknameController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  Rx<bool> isMale = true.obs;

  Future<void> signUpButton() async {
    isSignupLoading(true);
    if (nicknameController.text == '') {
      isSignupLoading(false);
      openAlertDialog(title: '닉네임을 입력해주세요');
    } else if (schoolController.text == '') {
      isSignupLoading(false);
      openAlertDialog(title: '학교를 입력해주세요');
    } else {
      UserModel userData = UserModel(
        uid: uid.value,
        nickname: nicknameController.text,
        loginType: AuthController.loginType,
        email: email.value,
        gender: isMale.value ? 'male' : 'female',
        school: schoolController.text,
        isTimer: false,
        totalSeconds: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await UserRepository.signup(userData);
      isSignupLoading(false);
      Get.off(App());
    }
  }
}
