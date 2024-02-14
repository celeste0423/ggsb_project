import 'package:get/get.dart';

class DataAnalyzePageController extends GetxController {
  static DataAnalyzePageController get to => Get.find();

  Rx<DateTime> selectedDate = DateTime.now().obs;

  void onDaySelected(DateTime selectedDateTime){
    selectedDate(selectedDateTime);
  }

}