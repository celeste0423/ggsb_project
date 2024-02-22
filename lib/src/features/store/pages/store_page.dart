import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/store/controllers/store_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:rive/rive.dart';

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
          onTap: (){},
        ),
      ],
    );
  }

  Widget _adBox() {
    return Container(
      color: CustomColors.whiteBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _divider(),
          const SizedBox(height: 10),
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
      child: RiveAnimation.asset(
        'assets/riv/character.riv',
        stateMachines: ["character"],
        onInit: controller.onRiveInit,
      ),
    );
  }

  Widget _itemsTab() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.whiteBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          GetBuilder<StorePageController>(
            id: 'tabBar',
            builder: (_) => TabBar(
              controller: controller.categoryTabController,
              indicatorColor: CustomColors.mainBlue,
              tabs: [
                Tab(
                  child: Image.asset(
                    'assets/icons/hat.png',
                    colorBlendMode: BlendMode.srcIn,
                    color: controller.categoryTabController.index == 0
                        ? CustomColors.mainBlack
                        : CustomColors.greyBackground,
                    height: 27,
                  ),
                ),
                Tab(
                  child: SvgPicture.asset(
                    'assets/icons/sheild.svg',
                    color: controller.categoryTabController.index == 1
                        ? CustomColors.mainBlack.withOpacity(0.7)
                        : CustomColors.greyBackground,
                    height: 25,
                  ),
                ),
                Tab(
                  child: SvgPicture.asset(
                    'assets/icons/color.svg',
                    color: controller.categoryTabController.index == 2
                        ? CustomColors.mainBlack.withOpacity(0.7)
                        : CustomColors.greyBackground,
                    height: 23,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.categoryTabController,
              children: List.generate(
                3,
                (categoryIndex) => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, itemIndex) {
                    return _itemCard(
                      categoryIndex,
                      itemIndex,
                      false,
                      false,
                      controller.itemList[categoryIndex][itemIndex][0],
                      controller.itemList[categoryIndex][itemIndex][1],
                    );
                  },
                  itemCount: controller.itemList[categoryIndex].length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _itemCard(
      int categoryIndex,
      int itemIndex,
      bool isSelected,
      bool isUnlocked,
      String assetPath,
      int price,
      ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.itemButton(categoryIndex.toDouble(), itemIndex.toDouble());
      },
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.whiteBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isUnlocked ? Colors.transparent : CustomColors.greyBackground,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이템 이미지 또는 아이콘
            Image.asset(
              'assets/icons/hat.png',
              width: 50,
              height: 50,
            ),
            SizedBox(height: 8),
            // 아이템 가격 표시
            Text(
              '$price',
              style: TextStyle(
                color: CustomColors.blackText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
            Expanded(child: _itemsTab()),
          ],
        ));
  }
}
