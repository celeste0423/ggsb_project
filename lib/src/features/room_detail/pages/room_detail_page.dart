import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/room_detail/controllers/room_detail_page_controller.dart';

class RoomDetailPage extends GetView<RoomDetailPageController> {
  const RoomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RoomDetailPageController);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Text('랭킹페이지- 추후 구현 예정'),
      ),
    );
  }
}
