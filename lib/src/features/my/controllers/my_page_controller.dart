import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/time_model.dart';
import 'package:ggsb_project/src/repositories/time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';

class MyPageController extends GetxController {
  static MyPageController get to => Get.find();

  List<TimeModel> timeModelList = [];
  int bestSeconds = 0;
  int totalSeconds = 0;
  String totalSecondsDigit = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Stream<List<TimeModel>> timeModelStream() {
    return TimeRepository().timeListStream(AuthController.to.user.value.uid!);
  }

  void arrangeTimeModels(AsyncSnapshot<List<TimeModel>> snapshot) {
    timeModelList = DateUtil().sortByDay(snapshot.data!);
    for (TimeModel timeModel in timeModelList) {
      if (timeModel.totalSeconds! > bestSeconds) {
        bestSeconds = timeModel.totalSeconds!;
      }
      totalSeconds += timeModel.totalSeconds!;
    }
    totalSecondsDigit = SecondsUtil.convertToDigitString(totalSeconds);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
