import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/app.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/auth/pages/signup_page.dart';
import 'package:ggsb_project/src/features/auth/pages/welcome_page.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/models/user_model.dart';

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
                  return fullSizeLoadingIndicator();
                } else if (snapshot.hasData) {
                  return const App();
                } else {
                  return Obx(
                    () => controller.user.value.uid != null
                        //받은 컨트롤러의 유저 데이터가 이미 있을경우 앱으로, 아니면 회원가입창으로
                        ? const App()
                        : SignupPage(),
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
