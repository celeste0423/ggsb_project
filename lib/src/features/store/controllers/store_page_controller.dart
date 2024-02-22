import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rive/rive.dart';

class StorePageController extends GetxController
    with GetTickerProviderStateMixin {
  static StorePageController get to => Get.find();

  late TabController categoryTabController;

  RewardedAd? _rewardedAd;
  Map<String, String> unitId = kReleaseMode
      ? {
          'ios': dotenv.env['IOS_AD_UNIT_ID'] ?? '',
          'android': dotenv.env['ANDROID_AD_UNIT_ID'] ?? '',
        }
      : {
          'ios': 'ca-app-pub-3940256099942544/1712485313',
          'android': 'ca-app-pub-3940256099942544/5224354917',
        };
  Rx<int> rewardedAdCount = 0.obs;

  SMINumber? characterHat;
  SMINumber? characterColor;

  List<List<List<dynamic>>> itemList = [
    [
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
  ];
  List<Rx<int>> selectedIndex = [
    0.obs,
    0.obs,
    0.obs,
  ];

  @override
  void onInit() async {
    super.onInit();
    _categoryTabControllerInit();
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
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              //ui 업데이트 필요
              ad.dispose();
              _rewardedAd = null;
              //
              loadRewardedAd();
            },
          );

          //ui 업데이트 필요
          _rewardedAd = ad;
          //
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
  }

  void adButton() {
    rewardedAdCount(rewardedAdCount.value + 1);
    loadRewardedAd();
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
