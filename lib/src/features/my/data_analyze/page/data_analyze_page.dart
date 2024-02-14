import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/my/data_analyze/controller/data_analyze_controller.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class DataAnalyzePage extends GetView<DataAnalyzePageController> {
  const DataAnalyzePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      title: TitleText(
        text: '기록 분석',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DataAnalyzePageController());
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Text('추후 구현 예정입니다'),
        ),
      ),
    );
  }


}