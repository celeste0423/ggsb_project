import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPageController extends GetxController {
  static MyPageController get to => Get.find();

  List<StudyTimeModel> studyTimeModelList = [];
  int bestSeconds = 0;
  int totalSeconds = 0;
  String totalSecondsDigit = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Stream<List<StudyTimeModel>> timeModelStream() {
    print('스트림 받아옴');
    return StudyTimeRepository()
        .studyTimeListStream(AuthController.to.user.value.uid!, DateTime.now());
  }

  void arrangeTimeModels(AsyncSnapshot<List<StudyTimeModel>> snapshot) {
    studyTimeModelList = DateUtil().sortByDateString(snapshot.data!);
    for (StudyTimeModel studyTimeModel in studyTimeModelList) {
      print('정리중 ${studyTimeModel.date} / ${studyTimeModel.totalSeconds}');
      if (studyTimeModel.totalSeconds! > bestSeconds) {
        bestSeconds = studyTimeModel.totalSeconds!;
      }
      totalSeconds += studyTimeModel.totalSeconds!;
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
