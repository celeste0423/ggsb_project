import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/shop/controller/shop_page_controller.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class ShopPage extends GetView<ShopPageController> {
  const ShopPage({super.key});

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
    Get.put(ShopPageController());
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
