import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/app.dart';
import 'package:ggsb_project/src/constants/admin_email.dart';
import 'package:ggsb_project/src/features/admin/pages/admin_page.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/auth/pages/signup_page.dart';
import 'package:ggsb_project/src/features/auth/pages/welcome_page.dart';
import 'package:ggsb_project/src/features/timer/pages/timer_page.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';

class Root extends GetView<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return FutureBuilder<UserModel?>(
              future: controller.loginUser(user.data!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const FullSizeLoadingIndicator();
                } else {
                  return Obx(
                    () {
                      if (controller.user.value.uid != null) {
                        //받은 컨트롤러의 유저 데이터가 이미 있을경우 앱으로, 아니면 회원가입창으로
                        if (user.data!.email == AdminEmail.adminEmail) {
                          return const AdminPage();
                        } else if (!controller.user.value.isTimer!) {
                          return const App();
                        } else {
                          // print('시간 측정중이었음');
                          return const TimerPage();
                        }
                      } else {
                        return SignupPage(
                          uid: user.data!.uid,
                          email: user.data!.email!,
                        );
                      }
                    },
                  );
                  // : SignupPage(uid: user.data!.uid));
                }
              });
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
