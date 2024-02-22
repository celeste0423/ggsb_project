import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class StorePageController extends GetxController
    with GetTickerProviderStateMixin {
  static StorePageController get to => Get.find();

  late TabController categoryTabController;

  Map<String, String> unitId = kReleaseMode
      ? {
          'ios': dotenv.env['IOS_AD_UNIT_ID'] ?? '',
          'android': dotenv.env['ANDROID_AD_UNIT_ID'] ?? '',
        }
      : {
          'ios': 'ca-app-pub-3940256099942544/2934735716',
          'android': 'ca-app-pub-3940256099942544/6300978111',
        };

  SMINumber? characterHat;
  SMINumber? characterColor;

  List<List<List<dynamic>>> itemList = [
    [
      [
        'assets/items/pencil.png',
        10,
      ],
      [
        'assets/items/eraser.png',
        10,
      ],
      [
        'assets/items/pencil.png',
        10,
      ]
    ],
    [
      [
        'assets/items/pencil.png',
        10,
      ],
      [
        'assets/items/pencil.png',
        10,
      ]
    ],
    [
      [
        'assets/items/pencil.png',
        10,
      ],
      [
        'assets/items/pencil.png',
        10,
      ]
    ],
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

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
  }

  void itemButton(double categoryIndex, double itemIndex) {
    print('카테고리 ${categoryIndex} 아이템 ${itemIndex}');
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
