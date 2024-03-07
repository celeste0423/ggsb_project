import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/ranking/controllers/ranking_page_controller.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RankingPage extends GetView<RankingPageController> {
  const RankingPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      title: TitleText(
        text: '랭킹',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RankingPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Text('곧 출시됩니다'),
        ),
      ),
    );
  }
}
