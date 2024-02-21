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
    return Expanded(
      child: Container(),
    );
  }

  Widget _itemsTab() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.whiteBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, -2),
              blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: controller.categoryTabController,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.coffee,
                  color: controller.categoryTabController.index == 0
                      ? CustomColors.greyBackground
                      : CustomColors.lightGreyBackground,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.coffee,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.coffee,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.categoryTabController,
              children: [
                Container(height: 100, color: Colors.green),
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(
    bool isSelected,
    bool isUnlocked,
    String assetPath,
    int price,
  ) {
    return Container();
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
            Expanded(child: _itemsTab()),
          ],
        ));
  }
}
