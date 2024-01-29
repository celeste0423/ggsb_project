import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }

  static additionalBinding() {
    Get.put(HomePageController(), permanent: true);
    // Get.put(RoomListPage(), permanent: true);
  }

  // void refreshHomePageController() {
  //   Get.delete<HomePageController>();
  //   Get.put(HomePageController(), permanent: true);
  // }

  void refreshRoomListPageController() {
    Get.delete<RoomListPageController>();
    // RoomListPageController().dispose();
  }
}
