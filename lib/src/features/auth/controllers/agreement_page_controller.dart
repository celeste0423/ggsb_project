import 'package:get/get.dart';
import 'package:ggsb_project/src/app.dart';

class AgreementPageController extends GetxController {
  RxList<bool> isChecked = List.generate(5, (_) => false).obs;

  bool get buttonActive => isChecked[1] && isChecked[2] && isChecked[3];

  void updateCheckState(int index) {
    if (index == 0) {
      bool isAllChecked = !isChecked.every((element) => element);
      isChecked = List.generate(5, (index) => isAllChecked).obs;
    } else {
      isChecked[index] = !isChecked[index];
      isChecked[0] = isChecked.sublist(1).every((element) => element);
    }
  }

  void goToAppPage() {
    if (buttonActive) {
      Get.offAll(() => App());
    }
  }
}
