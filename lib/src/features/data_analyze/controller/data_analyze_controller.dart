import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

class DataAnalyzePageController extends GetxController {
  static DataAnalyzePageController get to => Get.find();

  DateTime now = DateTime.now();
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<StudyTimeModel> selectedStudyTime = StudyTimeModel().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  List<StudyTimeModel> studyTimeModelList = [];

  @override
  void onInit() async {
    super.onInit();
    await onMonthChagned(now);
    onDaySelected(now);
  }

  void onDaySelected(DateTime selectedDateTime) {
    bool isStudyTimeModelExist = false;
    selectedDay(selectedDateTime);
    // print(studyTimeModelList.length);
    String date = DateUtil().dateTimeToString(selectedDateTime);
    for (StudyTimeModel studyTimeModel in studyTimeModelList) {
      if (studyTimeModel.date == date) {
        selectedStudyTime(studyTimeModel);
        isStudyTimeModelExist = true;
      }
    }
    if (!isStudyTimeModelExist) {
      selectedStudyTime(StudyTimeModel(totalSeconds: 0));
    }
  }

  Future<void> onMonthChagned(DateTime day) async {
    DateTime firstDayOfMonth = DateTime(day.year, day.month, 1);
    DateTime lastDayOfMonth = DateTime(day.year, day.month + 1, 0);
    studyTimeModelList = await StudyTimeRepository().getStudyTimeInRange(
      AuthController.to.user.value.uid!,
      firstDayOfMonth,
      lastDayOfMonth,
    );
  }

  List<StudyTimeModel> getEvents(DateTime day) {
    for (StudyTimeModel studyTimeModel in studyTimeModelList) {
      String date = DateUtil().dateTimeToString(day);
      if (studyTimeModel.date == date && studyTimeModel.totalSeconds != 0) {
        return [studyTimeModel];
      }
    }
    return [];
  }
}
