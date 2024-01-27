import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:intl/intl.dart';

class TimerPageController extends GetxController
    with GetTickerProviderStateMixin {
  static TimerPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;
  Rx<bool> isTimer = false.obs;

  late Timer _secondsTimer;

  final Rx<String> today =
      DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  AnimateIconController animateIconController = AnimateIconController();

  late List<RoomModel> roomList;
  late TabController roomTabController;
  Rx<bool> noRooms = false.obs;

  String toOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' + 'th';
    }
    switch (number % 10) {
      case 1:
        return '$number' + 'st';
      case 2:
        return '$number' + 'nd';
      case 3:
        return '$number' + 'rd';
      default:
        return '$number' + 'th';
    }
  }

  Rx<int> indicatorCount = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getRoomList();
    _secondsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      update(['roomListTimer']);
    });
    roomTabController.addListener(() {
      update(['tabIndicator']);
    });
  }

  Future<void> getRoomList() async {
    isPageLoading(true);
    noRooms(AuthController.to.user.value.roomIdList == null ||
        AuthController.to.user.value.roomIdList!.isEmpty);
    if (!noRooms.value) {
      roomList = await RoomRepository()
          .getRoomList(AuthController.to.user.value.roomIdList!);
    }
    roomTabController = TabController(
      initialIndex: 0,
      length: noRooms.value ? 0 : roomList!.length,
      vsync: this,
    );
    indicatorCount(noRooms.value ? 0 : roomList!.length);
    update(['tabIndicator']);
    isPageLoading(false);
  }

  RoomStreamModel calcTotalLiveSec(RoomStreamModel roomStreamModel) {
    late int liveTotalSeconds;
    if (roomStreamModel.isTimer == false) {
      liveTotalSeconds = roomStreamModel.totalSeconds!;
    } else {
      int calcSec =
          DateTime.now().difference(roomStreamModel.startTime!).inSeconds;
      liveTotalSeconds = calcSec;
    }
    RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
      totalLiveSeconds: liveTotalSeconds,
    );
    return updatedRoomStreamModel;
  }

  Stream<List<RoomStreamModel>> roomListStream(String roomId) {
    return RoomStreamRepository().roomListStream(roomId);
  }

  Future<void> playButton() async {
    isTimer(true);
    //방별 roomStream 설정
    roomList.forEach((RoomModel roomModel) async {
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        AuthController.to.user.value.uid!,
      );
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        isTimer: true,
        startTime: DateTime.now(),
      );
      await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
    });
  }

  Future<void> stopButton() async {
    isTimer(false);
    //방별 roomStream 설정
    roomList.forEach((RoomModel roomModel) async {
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        AuthController.to.user.value.uid!,
      );
      //Todo: totalSeconds 계산
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        isTimer: false,
        lastTime: DateTime.now(),
      );
      await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _secondsTimer.cancel();
  }
}
