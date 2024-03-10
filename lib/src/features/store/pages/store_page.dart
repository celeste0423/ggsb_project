import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/store/controllers/store_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/number_util.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:rive/rive.dart';

class StorePage extends GetView<StorePageController> {
  const StorePage({Key? key});

  Widget cashDialog(int addedCash) {
    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: 30, vertical: Get.height / 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              '축하합니다',
              style: TextStyle(
                color: CustomColors.mainBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Container(
            //   child: RiveAnimation.asset(
            //     'assets/riv/coin.riv',
            //   ),
            // ),
            Image.asset(
              'assets/icons/gold_coin.png',
              width: Get.height / 3 - 130,
              height: Get.height / 3 - 130,
            ),
            Text(
              'x${addedCash}',
              style: const TextStyle(
                color: CustomColors.mainBlue,
                fontSize: 14,
              ),
            ),
            Text(
              '총 공부시간 ${addedCash}분에 대한 코인이 지급되었습니다',
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: CustomColors.mainBlack,
                fontSize: 14,
              ),
            ),
            MainButton(
              buttonText: '확인',
              height: 45,
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

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
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Obx(
            () => ImageIconButton(
              assetPath: 'assets/icons/check.svg',
              iconColor: controller.isItemChanged.value
                  ? CustomColors.mainBlue
                  : CustomColors.lightGreyBackground,
              height: 17,
              onTap: () {
                controller.completeButton();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _adBox() {
    return Container(
      color: CustomColors.whiteBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // CupertinoButton(
          //   padding: const EdgeInsets.only(right: 20),
          //   onPressed: () {
          //     controller.couponButton();
          //   },
          //   child: Image.asset(
          //     'assets/icons/coupon.png',
          //     color: CustomColors.greyBackground,
          //     height: 22,
          //   ),
          // ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              controller.adButton();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChatBubble(
                      clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
                      alignment: Alignment.centerRight,
                      backGroundColor: controller.rewardedAdCount.value == 0
                          ? CustomColors.greyBackground
                          : CustomColors.mainBlue,
                      child: Text(
                        '광고로 코인 충전 (${controller.rewardedAdCount.value}/10)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3, bottom: 3),
                      child: Image.asset(
                        'assets/icons/gold_coin.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          width: 12,
                          height: 12,
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: CustomColors.mainBlue,
                          ),
                          child: Image.asset('assets/icons/plus.png'),
                        )),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),
          Obx(
            () => Text(
              NumberUtil.formatNumber(controller.cash.value),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterBox() {
    return Expanded(
      child: Stack(
        children: [
          RiveAnimation.asset(
            'assets/riv/character.riv',
            stateMachines: ["character"],
            onInit: controller.onRiveInit,
          ),
          Obx(
            () => Visibility(
              visible: controller.isPurchaseButton.value,
              child: Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: MainButton(
                    buttonText: '구매',
                    width: 100,
                    height: 45,
                    onTap: () {
                      controller.purchaseButton();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  child: Image.asset(
                    'assets/icons/color.png',
                    color: controller.categoryTabController.index == 2
                        ? null
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
                    // crossAxisSpacing: 5,
                    // mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, itemIndex) {
                    return _itemCard(
                      categoryIndex,
                      itemIndex,
                      controller.itemList[categoryIndex][itemIndex][1],
                      controller.itemList[categoryIndex][itemIndex][2],
                      controller.itemList[categoryIndex][itemIndex][3],
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
    var assetPath,
    String name,
    int price,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.itemButton(categoryIndex, itemIndex);
      },
      child: Obx(
        () => Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CustomColors.whiteBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.selectedIndex[categoryIndex].value == itemIndex
                  ? CustomColors.mainBlue
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: assetPath == 'base'
              ? const Icon(
                  Icons.block,
                  color: CustomColors.greyBackground,
                  size: 80,
                )
              : FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      categoryIndex != 2
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                assetPath,
                                width: 80,
                                height: 80,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: assetPath,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                      Visibility(
                        visible: name != '',
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: CustomColors.blackText,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !controller
                            .isItemUnlockedList[categoryIndex][itemIndex].value,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/gold_coin.png',
                              width: 20,
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '$price',
                                style: const TextStyle(
                                  color: CustomColors.blackText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StorePageController());
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(),
          body: Column(
            children: [
              _adBox(),
              _characterBox(),
              Expanded(child: _itemsTab()),
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isPageLoading.value,
            child: FullSizeLoadingIndicator(
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
