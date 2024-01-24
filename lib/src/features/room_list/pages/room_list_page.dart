import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';

class RoomListPage extends GetView<RoomListPageController> {
  const RoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RoomListPageController());
    return Container();
  }
}
