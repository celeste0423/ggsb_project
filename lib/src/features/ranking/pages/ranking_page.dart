import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/ranking/controllers/ranking_page_controller.dart';

class RankingPage extends GetView<RankingPageController> {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RankingPageController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Text('랭킹페이지- 추후 구현 예정'),
        ),
      ),
    );
  }
}
