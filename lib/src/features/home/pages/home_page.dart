import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return Container();
  }
}
