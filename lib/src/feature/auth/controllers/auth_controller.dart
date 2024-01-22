import 'package:get/get.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Rx<UserModel> user = UserModel().obs;

  Future<UserModel?> loginUser(String uid) async {
    var userData = await UserRepository.loginUserByUid(uid);
    if (userData != null) {
      user(userData);
      // InitBinding.additionalBinding();
    }
    return userData;
  }
}
