import 'dart:async';

import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_add/pages/room_add_page.dart';
import 'package:ggsb_project/src/features/timer/pages/timer_page.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:intl/intl.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();

  Rx<String> totalTime = '00:00:00'.obs;
  Rx<String> totalHours = '00'.obs;
  Rx<String> totalMinutes = '00'.obs;
  Rx<String> totalSeconds = '00'.obs;

  Rx<String> today = DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    // totalTime(
    //   SecondsUtil.convertToDigitString(
    //     AuthController.to.timeModel.value.totalSeconds!,
    //   ),
    // );
    countUpHours();
    countUpMinutes();
    countUpSeconds();
  }

  Future<void> countUpHours() async {
    int i = 0;
    void count() {
      print(SecondsUtil.convertToHours(
          AuthController.to.timeModel.value.totalSeconds!));
      i++;
      if (i <=
          SecondsUtil.convertToHours(
              AuthController.to.timeModel.value.totalSeconds!)) {
        Timer(Duration(milliseconds: 100), count);
        String hour = SecondsUtil.digits(i);
        totalHours(hour);
      }
    }

    count();
  }

  Future<void> countUpMinutes() async {
    int i = 0;
    void count() {
      i++;
      if (i <=
          SecondsUtil.convertToMinutes(
              AuthController.to.timeModel.value.totalSeconds!)) {
        Timer(Duration(milliseconds: 30), count);
        String hour = SecondsUtil.digits(i);
        totalMinutes(hour);
      }
    }

    count();
  }

  Future<void> countUpSeconds() async {
    int i = 0;
    void count() {
      i++;
      if (i <=
          SecondsUtil.convertToSeconds(
              AuthController.to.timeModel.value.totalSeconds!)) {
        Timer(Duration(milliseconds: 30), count);
        String hour = SecondsUtil.digits(i);
        totalSeconds(hour);
      }
    }

    count();
  }

  void addRoomButton() {
    Get.to(() => RoomAddPage(), transition: Transition.rightToLeft);
  }

  void timerPageButton() {
    Get.to(() => TimerPage());
  }
}
