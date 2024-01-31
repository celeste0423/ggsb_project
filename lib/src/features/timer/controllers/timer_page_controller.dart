import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/time_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/time_repository.dart';
import 'package:ggsb_project/src/utils/calcTotalLiveSeconds.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:intl/intl.dart';
import 'package:status_bar_control/status_bar_control.dart';

class TimerPageController extends GetxController
    with GetTickerProviderStateMixin {
  static TimerPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;
  Rx<bool> isTimer = false.obs;

  late Timer _secondsTimer;

  final Rx<String> today =
      DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  AnimateIconController animateIconController = AnimateIconController();

  Rx<String> totalLiveTime = '00:00:00'.obs;

  Rx<bool> noRooms = false.obs;
  late List<RoomModel> roomList;
  late TabController roomTabController;
  List<RoomStreamModel> roomStreamList = [];
  List<RoomStreamModel> liveRoomStreamList = [];

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
    isTimerCheck();
    calcTotalLiveSec();
    _secondsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('타이머 작동중');
      if (isTimer.value) {
        calcTotalLiveSec();
      }
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

  void isTimerCheck() {
    isTimer(AuthController.to.timeModel.value.isTimer);
    if (isTimer.value) {
      animateIconController.animateToEnd();
    }
  }

  void calcTotalLiveSec() {
    late int liveTotalSeconds;
    TimeModel timeModel = AuthController.to.timeModel.value;
    // print('이전 전체 시간 ${timeModel.totalSeconds}');
    if (timeModel.isTimer == false) {
      liveTotalSeconds = timeModel.totalSeconds!;
    } else {
      // print('시간 확인 ${AuthController.to.timeModel.value.toJson()}');
      int calcSec = SecondsUtil.calculateDifferenceInSeconds(
        timeModel.startTime!,
        DateTime.now(),
      );
      liveTotalSeconds = timeModel.totalSeconds! + calcSec;
      print('현재 전체 시간 ${liveTotalSeconds}');
    }
    totalLiveTime(SecondsUtil.convertToDigitString(liveTotalSeconds));
  }

  Stream<List<RoomStreamModel>> roomListStream(String roomId) {
    return RoomStreamRepository().roomStreamListStream(roomId);
  }

  void arrangeSnapshot(AsyncSnapshot<List<RoomStreamModel>> snapshot) {
    roomStreamList = snapshot.data!;
    liveRoomStreamList = List.from(roomStreamList);
    // liveRoomStreamList에 대한 totalLiveSeconds 계산
    for (int i = 0; i < liveRoomStreamList.length; i++) {
      liveRoomStreamList[i] = CalcTotalLiveSeconds.calcTotalLiveSecInRoomStream(
          liveRoomStreamList[i]);
    }
    // totalLiveSeconds를 기준으로 리스트를 큰 순서대로 정렬
    liveRoomStreamList
        .sort((a, b) => b.totalLiveSeconds!.compareTo(a.totalLiveSeconds!));
  }

  Future<void> startButton() async {
    DateTime now = DateTime.now();
    isTimer(true);
    //상단바 색상
    await StatusBarControl.setColor(CustomColors.mainBlack, animated: true);
    // await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);

    //개인 timeModel 설정
    AuthController().updateTimeModel(AuthController.to.user.value.uid!);
    TimeModel updatedTimeModel = AuthController.to.timeModel.value.copyWith(
      isTimer: true,
      startTime: now,
    );
    TimeRepository().updateTimeModel(updatedTimeModel);
    AuthController.to.timeModel(updatedTimeModel);
    //방별 roomStream 설정
    roomList.forEach((RoomModel roomModel) async {
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        AuthController.to.user.value.uid!,
      );
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        isTimer: true,
        startTime: now,
      );
      if (roomModel.roomType == 'day') {
        updatedRoomStreamModel = updatedRoomStreamModel.copyWith(
          totalSeconds: updatedTimeModel.totalSeconds,
        );
      }
      await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
    });
  }

  Future<void> stopButton() async {
    DateTime now = DateTime.now();
    int totalSec = 0;
    int totalSecRoomStream = 0;
    int diffSec = 0;

    isTimer(false);
    //상단바 색상
    await StatusBarControl.setColor(Colors.white, animated: true);
    // await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);

    //개인 timeModel 업로드
    TimeModel timeModel = AuthController.to.timeModel.value;
    if (DateUtil.calculateDateDifference(timeModel.startTime!, now) >= 1) {
      //시간 측정중 하루가 넘어감
      datePassedWhileIsTimer(now);
    } else {
      diffSec = SecondsUtil.calculateDifferenceInSeconds(
        AuthController.to.timeModel.value.startTime!,
        now,
      );
      totalSec = AuthController.to.timeModel.value.totalSeconds! + diffSec;
      TimeModel updatedTimeModel = AuthController.to.timeModel.value.copyWith(
        isTimer: false,
        lastTime: now,
        totalSeconds: totalSec,
      );
      TimeRepository().updateTimeModel(updatedTimeModel);
      AuthController.to.timeModel(updatedTimeModel);
      HomePageController.to.totalTime(totalLiveTime.value);
    }

    //방별 roomStream 설정
    roomList.forEach((RoomModel roomModel) async {
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        AuthController.to.user.value.uid!,
      );
      if (roomModel.roomType == 'day') {
        totalSecRoomStream = totalSec;
      } else if (roomModel.roomType == 'week') {
        totalSecRoomStream = roomStreamModel.totalSeconds! + diffSec;
      }
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        isTimer: false,
        lastTime: now,
        totalSeconds: totalSecRoomStream,
      );
      await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
    });
  }

  Future<void> datePassedWhileIsTimer(DateTime now) async {
    //Todo: 만약 유저가 24시간 이상 타이머를 켜놓는다면 이슈 발생
    final fourAM = DateUtil.standardRefreshTime(now);
    TimeModel previousTimeModel = AuthController.to.timeModel.value;
    // 전날 startTime부터 새벽 4시까지 공부한 분량 계산
    final previousDiffSec =
        previousTimeModel.startTime!.difference(fourAM).inSeconds;
    final previousTotalSec = previousTimeModel.totalSeconds! + previousDiffSec;
    // 전 day doc에 업데이트
    final previousUpdatedTimeModel = previousTimeModel.copyWith(
      isTimer: false,
      lastTime: fourAM,
      totalSeconds: previousTotalSec,
    );
    await TimeRepository().updateTimeModel(previousUpdatedTimeModel);

    // 오늘자의 새벽 4시부터 lastTime까지의 seconds 차이 계산
    final todayDiffSec = now.difference(fourAM).inSeconds;
    // 오늘자 day doc에 업데이트
    final todayUpdatedTimeModel = previousTimeModel.copyWith(
      day: DateUtil.getDayOfWeek(now),
      isTimer: false,
      startTime: fourAM,
      lastTime: now,
      totalSeconds: todayDiffSec,
    );
    await TimeRepository().updateTimeModel(todayUpdatedTimeModel);
  }

  @override
  void onClose() {
    super.onClose();
    _secondsTimer.cancel();
  }
}
