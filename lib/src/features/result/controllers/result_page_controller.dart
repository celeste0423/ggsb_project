import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class ResultPageController extends GetxController
    with GetTickerProviderStateMixin {
  static ResultPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;

  List<RoomModel> roomModelList = [];
  List<List<StudyTimeModel?>> studyTimeModelList = [];
  late StudyTimeModel myStudyTime;

  SMINumber? characterHat;
  SMINumber? characterColor;

  late TabController roomTabController;
  int indicatorCount = 0;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void onInit() async {
    super.onInit();
    isPageLoading(true);
    roomModelList = await _getRoomList();
    await _initRoomTabController();
    isPageLoading(false);
  }

  Future<List<RoomModel>> _getRoomList() async {
    if (AuthController.to.user.value.roomIdList == null) {
      return [];
    } else {
      List<RoomModel> roomList = await RoomRepository()
          .getRoomList(AuthController.to.user.value.roomIdList!);
      return roomList;
    }
  }

  Future<void> _initRoomTabController() async {
    roomTabController = TabController(
      initialIndex: 0,
      length: roomModelList.length,
      vsync: this,
    );
    indicatorCount = roomModelList.length;
    update(['tabIndicator']);
    roomTabController.addListener(
      () {
        update(['tabIndicator']);
      },
    );
  }

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterHat = riveController.findInput<double>('hat') as SMINumber;
    characterColor = riveController.findInput<double>('color') as SMINumber;
    riveCharacterInit();
  }

  void riveCharacterInit() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData!;
    characterHat!.value = characterModel.hat!.toDouble();
    characterColor!.value = characterModel.bodyColor!.toDouble();
  }

  Future<List<StudyTimeModel?>> getStudyTimeList(int index) async {
    List<StudyTimeModel?> modelList = [];
    for (String uid in roomModelList[index].uidList!) {
      String yesterday = DateUtil().dateTimeToString(
        // DateUtil().getYesterday(),
        DateTime.now(),
      );
      StudyTimeModel? studyTimeModel =
          await StudyTimeRepository().getStudyTimeModel(uid, yesterday);
      modelList.add(studyTimeModel);
      if (studyTimeModel!.uid == AuthController.to.user.value.uid) {
        myStudyTime = studyTimeModel;
      }
    }
    return modelList;
  }

  Future<String?> screenshot() async {
    var data = await screenshotController.capture(
        delay: const Duration(milliseconds: 10));
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }

  void shareScreenButton() async {
    var path = await screenshot();
    SocialShare.shareInstagramStory(
      appId: '1095966244764492',
      imagePath: path!,
      backgroundTopColor: "#5FA3D4",
      backgroundBottomColor: "#5FA3D4",
    ).then((value) => print(value));
    // SocialShare.shareFacebookStory(
    //   appId: '1095966244764492',
    //   imagePath: path!,
    //   backgroundTopColor: "#ffffff",
    //   backgroundBottomColor: "#000000",
    // ).then((value) => print(value));
  }

  void saveImageButton() async {
    openAlertDialog(title: '추후 지원 예정입니다.');
  }
}
