import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/features/my/controllers/my_page_controller.dart';
import 'package:ggsb_project/src/features/ranking/pages/ranking_page.dart';
import 'package:ggsb_project/src/features/room_list/pages/room_list_page.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }

  static additionalBinding() {
    Get.put(HomePageController(), permanent: true);
    Get.put(RoomListPage());
    // Get.put(RankingPage());
    Get.put(MyPageController());
  }

  // void refreshHomePageController() {
  //   Get.delete<HomePageController>();
  //   Get.put(HomePageController(), permanent: true);
  // }

  // void refreshRoomListPageController() {
  //   Get.delete<RoomListPageController>();
  //   // RoomListPageController().dispose();
  // }
}
