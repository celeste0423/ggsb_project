import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/store/controllers/store_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class StorePage extends GetView<StorePageController> {
  const StorePage({Key? key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: ImageIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: () {
          Get.back();
        },
      ),
      centerTitle: true,
      title: TitleText(
        text: '상점',
      ),
      actions: [
        ImageIconButton(
          assetPath: 'assets/icons/check.svg',
          iconColor: CustomColors.greyBackground,
          height: 17,
          onTap: Get.back,
        ),
      ],
    );
  }

  Widget _adBox() {
    return Container(
      color: CustomColors.whiteBackground,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _divider(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '25c',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Text(
                '광고로 코인 충전하기 +5',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: CustomColors.mainBlue,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    '(5/10)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            color: CustomColors.blackText,
          ),
        ),
      ),
    );
  }

  Widget _characterBox() {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.blackText,
      ),
    );
  }

  Widget _itemsTap() {
    return Column(
      children: [
        TabBar(
          controller: controller.categoryTabController,
          tabs: [
            Tab(icon: Icon(Icons.coffee, color: Colors.black)),
            Tab(icon: Icon(Icons.local_pizza, color: Colors.black)),
          ],
        ),
        // TabBarView(
        //   controller: controller.categoryTabController,
        //   children: [
        //     Container(color: Colors.green),
        //     Container(color: Colors.red),
        //   ],
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StorePageController());
    return Scaffold(
        backgroundColor: CustomColors.lightGreyBackground,
        appBar: _appBar(),
        body: Column(
          children: [
            _adBox(),
            _characterBox(),
            _itemsTap(),
          ],
        ));
  }
}
