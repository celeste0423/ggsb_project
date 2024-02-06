import 'package:flutter/material.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';

class AppleLoginButton extends StatelessWidget {
  String? userid;

  AppleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AuthController.to.signInWithApple();
        // print('apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
        //로그인 타입 설정
        AuthController.loginType = 'apple';
      },
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.2),),
            ),
            child: const Center(
              child: Text(
                'Apple로 로그인',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Image.asset(
              'assets/icons/apple.png',
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}
