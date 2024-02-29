import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

class ResultPageController extends GetxController
    with GetTickerProviderStateMixin {
  static ResultPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;

  List<RoomModel> roomModelList = [];
  List<List<StudyTimeModel?>> studyTimeModelList = [];

  late TabController roomTabController;

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
      // print('방 개수 ${roomList.length}');
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
      () async {
        int index = roomTabController.index;
        if (studyTimeModelList.length < index + 1) {
          studyTimeModelList
            ..add(
              await _getStudyTimeList(roomModelList[index]),
            );
        }
      },
    );
  }

  Future<List<StudyTimeModel?>> _getStudyTimeList(
    RoomModel roomModel,
  ) async {
    List<StudyTimeModel?> modelList = [];
    for (String uid in roomModel.uidList!) {
      String yesterday = DateUtil().dateTimeToString(
        DateUtil().getYesterday(),
      );
      StudyTimeModel? studyTimeModel =
          await StudyTimeRepository().getStudyTimeModel(uid, yesterday);
      modelList..add(studyTimeModel);
    }
    return modelList;
  }
}
