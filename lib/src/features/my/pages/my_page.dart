import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/my/controllers/my_page_controller.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyPageController());
    return Container();
  }
}
