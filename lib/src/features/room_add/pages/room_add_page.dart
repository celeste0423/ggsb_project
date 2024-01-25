import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomAddPage extends GetView<RoomListPageController> {
  const RoomAddPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leadingWidth: 75,
      leading: SvgIconButton(
        assetName: 'assets/icons/back.svg',
        onTap: () {
          Get.back();
        },
      ),
      title: TitleText(text: '새 공부방'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomListPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        color: Colors.white,
        child: Text('룸 리스트 페이지'),
      ),
    );
  }
}
