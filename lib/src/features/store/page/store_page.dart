import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/store/controllers/store_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class StorePage extends GetView<StorePageController> {
  const StorePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        children: [
          TitleText(
            text: '상점',
          ),
          Spacer(),
          IconButton(
              icon: Image.asset(
                'assets/icons/store.png',
                color: CustomColors.greyText,
                height: 25,
              ),
            onPressed: () {

            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StorePageController());
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
