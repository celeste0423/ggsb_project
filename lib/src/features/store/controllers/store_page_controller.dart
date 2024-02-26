import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePageController extends GetxController
    with GetTickerProviderStateMixin {
  static StorePageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;

  Rx<int> cash = AuthController.to.user.value.cash!.obs;

  Map<String, String> unitId = kReleaseMode
      ? {
          'ios': dotenv.env['IOS_AD_UNIT_ID'] ?? '',
          'android': dotenv.env['ANDROID_AD_UNIT_ID'] ?? '',
        }
      : {
          //test ad 재생시 필요한 unit id
          'ios': 'ca-app-pub-3940256099942544/1712485313',
          'android': 'ca-app-pub-3940256099942544/5224354917',
        };
  late SharedPreferences prefs;
  static int totalAdCount = 10;
  Rx<int> rewardedAdCount = 0.obs;

  SMINumber? actionState;
  SMINumber? characterHat;
  SMINumber? characterShield;
  SMINumber? characterColor;

  Rx<bool> isPurchaseButton = false.obs;

  late TabController categoryTabController;

  List<List<List<dynamic>>> itemList = [
    //id, path , price , isUnlocked
    [
      //모자 종류
      [
        'base',
        'base',
        0,
      ],
      [
        'eraserHat',
        'assets/items/hat/eraser.png',
        12,
      ],
      [
        'pencilHat',
        'assets/items/hat/pencil.png',
        10,
      ]
    ],
    //방패 종류
    [
      [
        'base',
        'assets/items/hat/pencil.png',
        10,
      ],
      [
        'base',
        'assets/items/hat/pencil.png',
        10,
      ],
      [
        'base',
        'assets/items/hat/pencil.png',
        10,
      ],
    ],
    //색 종류
    [
      [
        'base',
        CustomColors.baseCharacter,
        0,
      ],
      [
        'pinkColor',
        CustomColors.pinkCharacter,
        10,
      ],
      [
        'greenColor',
        CustomColors.greenCharacter,
        10,
      ],
      [
        'lightblueColor',
        CustomColors.lightBlueCharacter,
        10,
      ],
      [
        'redColor',
        CustomColors.redCharacter,
        10,
      ],
      [
        'yellowColor',
        CustomColors.yellowCharacter,
        10,
      ],
      [
        'orangeColor',
        CustomColors.orangeCharacter,
        10,
      ],
      [
        'purpleColor',
        CustomColors.purpleCharacter,
        10,
      ],
      [
        'greyColor',
        CustomColors.greyCharacter,
        10,
      ],
      [
        'blackColor',
        CustomColors.blackCharacter,
        10,
      ],
    ],
  ];
  late List<List<RxBool>> isItemUnlockedList = List<List<RxBool>>.generate(
    itemList.length,
    (categoryIndex) => List<RxBool>.generate(
      itemList[categoryIndex].length,
      (itemIndex) => false.obs,
    ),
  );
  List<Rx<int>> selectedIndex = [
    0.obs,
    0.obs,
    0.obs,
  ];

  @override
  void onInit() async {
    super.onInit();
    isPageLoading(true);
    _rewardedAdInit();
    _categoryTabControllerInit();
    _getIsItemUnlockedList();
    isPageLoading(false);
  }

  void _rewardedAdInit() async {
    prefs = await SharedPreferences.getInstance();
    rewardedAdCount.value = prefs.getInt('rewardedAdCount') ?? totalAdCount;
  }

  void _categoryTabControllerInit() {
    categoryTabController = TabController(length: 3, vsync: this);
    categoryTabController.addListener(() {
      if (categoryTabController.index == 1) {
        actionState!.value = 1.toDouble();
      } else {
        actionState!.value = 0.toDouble();
      }
      update(['tabBar']);
    });
  }

  void _getIsItemUnlockedList() {
    for (int categoryIndex = 0;
        categoryIndex < itemList.length;
        categoryIndex++) {
      for (int itemIndex = 0;
          itemIndex < itemList[categoryIndex].length;
          itemIndex++) {
        String itemId = itemList[categoryIndex][itemIndex][0];
        bool isUnlocked = itemList[categoryIndex][itemIndex][0] == 'base'
            ? true
            : AuthController.to.user.value.characterData!.purchasedItem!
                .contains(itemId);
        isItemUnlockedList[categoryIndex][itemIndex](isUnlocked);
      }
    }
  }

  //on init

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid ? unitId['android']! : unitId['ios']!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          });

          ad.show(onUserEarnedReward: (ad, reward) {
            onGetReward(reward);
          });
          isPageLoading(false);
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void onGetReward(RewardItem reward) {
    prefs.setInt('rewardedAdCount', rewardedAdCount.value - 1);
    rewardedAdCount(rewardedAdCount.value - 1);
    if (reward.amount > 0) {
      updateCash(5);
    }
  }

  void updateCash(int cashDifference) {
    UserModel updatedUserModel = AuthController.to.user.value.copyWith(
      cash: AuthController.to.user.value.cash! + cashDifference,
    );
    AuthController.to.updateUserModel(updatedUserModel);
    cash(AuthController.to.user.value.cash!);
  }

  void onRiveInit(Artboard artboard) {
    isPageLoading(true);
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    actionState = riveController.findInput<double>('action') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
    characterShield = riveController.findInput<double>('shield') as SMINumber;
    characterColor = riveController.findInput<double>('color') as SMINumber;
    _riveCharacterInit();
    isPageLoading(false);
  }

  void _riveCharacterInit() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData!;
    _selectIndex(0, characterModel.hat!);
    _selectIndex(1, characterModel.shield!);
    _selectIndex(2, characterModel.bodyColor!);
  }

  void _selectIndex(int categoryIndex, int itemIndex) {
    selectedIndex[categoryIndex](itemIndex);
    if (itemList[categoryIndex][itemIndex][1] != 'base' &&
        !isItemUnlockedList[categoryIndex][itemIndex].value) {
      isPurchaseButton(true);
    } else {
      isPurchaseButton(false);
    }
    switch (categoryIndex) {
      case 0:
        {
          characterHat!.value = itemIndex.toDouble();
        }
      case 1:
        {
          characterShield!.value = itemIndex.toDouble();
        }
      case 2:
        {
          characterColor!.value = itemIndex.toDouble();
        }
    }
  }

  void completeButton() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData!;
    int hatIndex = selectedIndex[0].value;
    int shieldIndex = selectedIndex[1].value;
    int bodyColorIndex = selectedIndex[2].value;
    if (isItemUnlockedList[0][hatIndex].value &&
        isItemUnlockedList[1][shieldIndex].value &&
        isItemUnlockedList[2][bodyColorIndex].value) {
      CharacterModel updatedCharacterModel = characterModel.copyWith(
        hat: hatIndex,
        shield: shieldIndex,
        bodyColor: bodyColorIndex,
      );
      AuthController.to.updateCharacterModel(updatedCharacterModel, userModel);
      HomePageController.to.riveCharacterInit();
      Get.back();
    } else {
      openAlertDialog(title: '장착 불가', content: '아이템을 구매 후 이용해주세요');
    }
  }

  void adButton() {
    if (rewardedAdCount.value != 0) {
      isPageLoading(true);
      loadRewardedAd();
    } else {
      openAlertDialog(title: '광고 제한', content: '오늘 광고 시청 횟수를 초과했습니다.');
    }
  }

  void purchaseButton() {
    int categoryIndex = categoryTabController.index;
    int itemIndex = selectedIndex[categoryIndex].value;
    List<dynamic> selectedItem = itemList[categoryIndex][itemIndex];
    if (cash.value < selectedItem[2]) {
      openAlertDialog(title: '코인이 부족합니다.');
    } else {
      openAlertDialog(
        title: '상품을 구매하시겠습니까?',
        content: '총 ${selectedItem[2]}코인이 소모됩니다.',
        mainfunction: () {
          isPageLoading(true);
          updateCash(-selectedItem[2]);
          CharacterModel characterData =
              AuthController.to.user.value.characterData!;
          String itemId = selectedItem[0];
          //구매 정보 업데이트
          CharacterModel updatedCharacterModel = characterData.copyWith(
            purchasedItem: characterData.purchasedItem!..add(itemId),
          );
          AuthController.to.updateCharacterModel(
            updatedCharacterModel,
            AuthController.to.user.value,
          );
          _getIsItemUnlockedList();
          switch (categoryIndex) {
            case 0:
              {
                characterHat!.value = itemIndex.toDouble();
              }
            case 1:
              {
                characterHat!.value = itemIndex.toDouble();
              }
            case 2:
              {
                characterColor!.value = itemIndex.toDouble();
              }
          }
          isPageLoading(false);
          Get.back();
        },
        secondButtonText: '취소',
      );
    }
  }

  void itemButton(int categoryIndex, int itemIndex) {
    _selectIndex(categoryIndex, itemIndex);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
