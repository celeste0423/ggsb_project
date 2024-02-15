import 'package:get/get.dart';

class DataAnalyzePageController extends GetxController {
  static DataAnalyzePageController get to => Get.find();

  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;

  void onDaySelected(DateTime selectedDateTime) {
    selectedDay(selectedDateTime);
  }
}
