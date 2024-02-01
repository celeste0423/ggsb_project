import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/time_model.dart';
import 'package:ggsb_project/src/repositories/time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void onKakaoChannelPressed() async {
    Uri uri = Uri.parse(ServiceUrls.kakaoChatUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw '카카오톡 채널을 열 수 없습니다.';
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
