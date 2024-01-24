import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/ranking/controllers/ranking_page_controller.dart';

class RankingPage extends GetView<RankingPageController> {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RankingPageController());
    return Container();
  }
}
