import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePageController extends GetxController
    with GetTickerProviderStateMixin {
  static StorePageController get to => Get.find();

  Rx<int> cash = AuthController.to.user.value.cash!.obs;

  Map<String, String> unitId = kReleaseMode
      ? {
          'ios': dotenv.env['IOS_AD_UNIT_ID'] ?? '',
          'android': dotenv.env['ANDROID_AD_UNIT_ID'] ?? '',
        }
      : {
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
    [
      //모자 종류
      [
        'base',
        0,
      ],
      [
        'assets/items/hat/eraser.png',
        10,
      ],
      [
        'assets/items/hat/pencil.png',
        10,
      ]
    ],
    //방패 종류
    [
      [
        'base',
        0,
      ],
      [
        'assets/icons/hat.png',
        10,
      ]
    ],
    //색 종류
    [
      [
        'base',
        0,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
      ],
      [
        'assets/icons/hat.png',
        10,
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
      UserModel updatedUserModel = AuthController.to.user.value.copyWith(
        cash: AuthController.to.user.value.cash! + 5,
      );
      AuthController.to.updateUserModel(updatedUserModel);
      cash(AuthController.to.user.value.cash!);
    }
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

  void itemButton(double categoryIndex, double itemIndex) {
    // print('카테고리 ${categoryIndex} 아이템 ${itemIndex}');
    selectedIndex[categoryIndex.toInt()](itemIndex.toInt());
    switch (categoryIndex) {
      case 0:
        {
          characterHat!.value = itemIndex;
        }
      case 1:
        {
          characterHat!.value = itemIndex;
        }
      case 2:
        {
          characterColor!.value = itemIndex;
        }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
