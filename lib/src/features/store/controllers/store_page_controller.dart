import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
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

  SMINumber? characterHat;
  SMINumber? characterColor;

  late TabController categoryTabController;

  List<List<List<dynamic>>> itemList = [
    //path , price , isUnlocked , id
    [
      //모자 종류
      [
        'base',
        0,
        true,
        'base',
      ],
      [
        'assets/items/hat/eraser.png',
        10,
        AuthController.to.user.value.characterData!.purchasedHat!
            .contains('eraser'),
        'eraser',
      ],
      [
        'assets/items/hat/pencil.png',
        10,
        AuthController.to.user.value.characterData!.purchasedHat!
            .contains('pencil'),
        'pencil',
      ]
    ],
    //방패 종류
    [
      [
        'base',
        0,
        true,
        'base',
      ],
    ],
    //색 종류
    [
      [
        CustomColors.baseCharacter,
        0,
        true,
        'base',
      ],
      [
        CustomColors.pinkCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('pink'),
        'pink',
      ],
      [
        CustomColors.greenCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('green'),
        'green',
      ],
      [
        CustomColors.lightBlueCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('lightBlue'),
        'lightblue',
      ],
      [
        CustomColors.redCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('red'),
        'red',
      ],
      [
        CustomColors.yellowCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('yellow'),
        'yellow',
      ],
      [
        CustomColors.orangeCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('orange'),
        'orange',
      ],
      [
        CustomColors.purpleCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('purple'),
        'purple'
      ],
      [
        CustomColors.greyCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('grey'),
        'grey',
      ],
      [
        CustomColors.blackCharacter,
        10,
        AuthController.to.user.value.characterData!.purchasedBodyColor!
            .contains('black'),
        'black',
      ],
    ],
  ];
  List<Rx<int>> selectedIndex = [
    0.obs,
    0.obs,
    0.obs,
  ];
  List<List<String>> purchasedItem = [
    AuthController.to.user.value.characterData!.purchasedHat!,
    AuthController.to.user.value.characterData!.purchasedShield!,
    AuthController.to.user.value.characterData!.purchasedBodyColor!,
  ];

  @override
  void onInit() async {
    super.onInit();
    _rewardedAdInit();
    _categoryTabControllerInit();
  }

  void _rewardedAdInit() async {
    prefs = await SharedPreferences.getInstance();
    rewardedAdCount.value = prefs.getInt('rewardedAdCount') ?? totalAdCount;
  }

  void _categoryTabControllerInit() {
    categoryTabController = TabController(length: 3, vsync: this);
    categoryTabController.addListener(() {
      update(['tabBar']);
    });
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
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
  }

  void adButton() {
    if (rewardedAdCount.value != 0) {
      loadRewardedAd();
    } else {
      openAlertDialog(title: '광고 제한', content: '오늘 광고 시청 횟수를 초과했습니다.');
    }
  }

  void itemButton(int categoryIndex, int itemIndex) {
    selectedIndex[categoryIndex](itemIndex);
    if (itemList[categoryIndex][itemIndex][2]) {
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
    } else {
      openAlertDialog(
        title: '상품을 구매하시겠습니까?',
        content: '총 ${itemList[categoryIndex][itemIndex][1]}코인이 소모됩니다.',
        mainfunction: () {
          isPageLoading(true);
          updateCash(-itemList[categoryIndex][itemIndex][1]);
          switch (categoryIndex) {
            case 0:
              {
                CharacterModel characterData =
                    AuthController.to.user.value.characterData!;
                String itemId = itemList[categoryIndex][itemIndex][3];
                CharacterModel updatedCharacterModel = characterData.copyWith(
                  purchasedHat: characterData.purchasedHat!..add(itemId),
                );
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
        },
        secondButtonText: '취소',
        // secondfunction: () {
        //   Get.back();
        // },
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
