import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Rx<UserModel> user = UserModel().obs;
  static String? loginType;

  Future<UserModel?> loginUser(String uid) async {
    // print('로그인 중');
    var userData = await UserRepository.getUserData(uid);
    // print('유저 데이터 ${userData}');
    if (userData != null) {
      user(userData);
      InitBinding.additionalBinding();
    }
    return userData;
  }

  // 애플 로그인
  // Future<UserCredential> signInWithApple() async {
  //   bool isAvailable = await SignInWithApple.isAvailable();
  //
  //   if (isAvailable) {
  //     return await UserRepository.iosSignInWithApple();
  //   } else {
  //     return await UserRepository.appleFlutterWebAuth();
  //   }
  // }

  //구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    return await UserRepository.signInWithGoogle();
  }

  //페이스북 로그인
  Future<UserCredential> signInWithFacebook() async {
    return await UserRepository.signInWithFacebook();
  }
}
