import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_add/pages/room_add_page.dart';
import 'package:ggsb_project/src/features/timer/pages/timer_page.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:intl/intl.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();

  Rx<String> totalTime = '00:00:00'.obs;

  Rx<String> today = DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    totalTime(
      SecondsUtil.convertToDigitString(
        AuthController.to.timeModel.value.totalSeconds!,
      ),
    );
  }

  void addRoomButton() {
    Get.to(() => RoomAddPage());
  }

  void timerPageButton() {
    Get.to(() => TimerPage());
  }
}
