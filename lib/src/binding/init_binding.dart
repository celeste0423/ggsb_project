import 'package:get/get.dart';
import 'package:ggsb_project/src/feature/auth/controllers/auth_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }

  static additionalBinding() {}

  void refreshControllers() {}
}
