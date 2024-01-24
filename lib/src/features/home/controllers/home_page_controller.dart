import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();

  final Rx<String> today =
      DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
  }
}
