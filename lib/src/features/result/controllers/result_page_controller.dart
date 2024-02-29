import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class ResultPageController extends GetxController
    with GetTickerProviderStateMixin {
  static ResultPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;

  List<RoomModel> roomModelList = [];
  List<List<StudyTimeModel?>> studyTimeModelList = [];

  late TabController roomTabController;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void onInit() async {
    super.onInit();
    isPageLoading(true);
    roomModelList = await _getRoomList();
    await _initRoomTabController();
    isPageLoading(false);
    print('끝');
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
    roomTabController.addListener(
      () {
        int index = roomTabController.index;
      },
    );
  }

  Future<List<StudyTimeModel?>> getStudyTimeList(int index) async {
    List<StudyTimeModel?> modelList = [];
    for (String uid in roomModelList[index].uidList!) {
      String yesterday = DateUtil().dateTimeToString(
        DateUtil().getYesterday(),
      );
      StudyTimeModel? studyTimeModel =
          await StudyTimeRepository().getStudyTimeModel(uid, yesterday);
      modelList.add(studyTimeModel);
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
      backgroundTopColor: "#ffffff",
      backgroundBottomColor: "#000000",
    ).then((value) => print(value));
    // SocialShare.shareFacebookStory(
    //   appId: '1095966244764492',
    //   imagePath: path!,
    //   backgroundTopColor: "#ffffff",
    //   backgroundBottomColor: "#000000",
    // ).then((value) => print(value));
  }
}
