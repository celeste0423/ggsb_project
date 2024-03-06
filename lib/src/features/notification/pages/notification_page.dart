import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/notification/controller/notification_page_controller.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class NotificationPage extends GetView<NotificationPageController> {
  const NotificationPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      leading: ImageIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: Get.back,
      ),
      title: TitleText(
        text: '이벤트',
      ),
    );
  }

  Widget _eventCard(){
    return Container(

    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child:
          _eventCard(),

      ),
    );
  }
}
