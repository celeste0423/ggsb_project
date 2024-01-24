import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/login_type_enum.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        UserCredential? userCredential =
            await AuthController.to.signInWithGoogle();

        if (userCredential == '') {
          openAlertDialog(title: '로그인 실패');
        } else {
          print('(gog but) ${AuthController.to.user.value.nickname}');
          AuthController.loginType = LoginType.google;
        }
        Get.back();
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                'Google로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Image.asset(
              'assets/icons/google.png',
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
