import 'dart:async';
import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/live_seconds_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPageController extends GetxController
    with GetTickerProviderStateMixin {
  static TimerPageController get to => Get.find();

  Rx<bool> isPageLoading = false.obs;
  Rx<bool> isTimer = false.obs;

  late final AppLifecycleListener _appLifecycleListener;
  late final bool overlayPermissionStatus;

  late Timer _secondsTimer;

  final Rx<String> today =
      DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  AnimateIconController animateIconController = AnimateIconController();
  Rx<Color> playButtonColor = CustomColors.mainBlue.obs;

  Rx<String> totalLiveTime = '00:00:00'.obs;

  Rx<bool> noRooms = false.obs;
  late List<RoomModel> roomList;
  late TabController roomTabController;
  int activeIndex = 0;
  late SharedPreferences prefs;
  List<RoomStreamModel> roomStreamList = [];
  List<RoomStreamModel> liveRoomStreamList = [];

  int indicatorCount = 0;

  @override
  void onInit() async {
    super.onInit();
    await getRoomList();
    isTimerCheck();
    calcTotalLiveSec();
    _secondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      everySecondFunction();
    });
    await _initRoomTabController();
    await _initOverlay();
  }

  Future<void> getRoomList() async {
    isPageLoading(true);
    noRooms(AuthController.to.user.value.roomIdList == null ||
        AuthController.to.user.value.roomIdList!.isEmpty);
    if (!noRooms.value) {
      roomList = await RoomRepository()
          .getRoomList(AuthController.to.user.value.roomIdList!);
    }
    //기본 탭 세팅
    roomTabController = TabController(
      initialIndex: 0,
      length: noRooms.value ? 0 : roomList.length,
      vsync: this,
    );
    indicatorCount = noRooms.value ? 0 : roomList.length;
    update(['tabIndicator']);
    isPageLoading(false);
  }

  void isTimerCheck() {
    isTimer(AuthController.to.user.value.isTimer);
    if (isTimer.value) {
      animateIconController.animateToEnd();
    }
  }

  void calcTotalLiveSec() {
    late int liveTotalSeconds;
    StudyTimeModel studyTimeModel = AuthController.to.studyTime;
    // print(
    //     '이전 전체 시간 ${studyTimeModel.totalSeconds}, ${AuthController.to.user.value.isTimer}');
    if (AuthController.to.user.value.isTimer == false) {
      liveTotalSeconds = studyTimeModel.totalSeconds!;
    } else {
      // print('시간 확인 ${AuthController.to.studyTimeModel.value.toJson()}');
      int calcSec = SecondsUtil.calculateDifferenceInSeconds(
        studyTimeModel.startTime!,
        DateTime.now(),
      );
      liveTotalSeconds = studyTimeModel.totalSeconds! + calcSec;
      // print('현재 전체 시간 ${liveTotalSeconds}');
    }
    totalLiveTime(SecondsUtil.convertToDigitString(liveTotalSeconds));
  }

  void everySecondFunction() {
    // print('타이머 작동중');
    if (isTimer.value) {
      calcTotalLiveSec();
    }
    update(['roomListTimer']);
  }

  Future<void> _initRoomTabController() async {
    if (roomTabController.length <= 1) {
      playButtonColor(CustomColors.nameToRoomColor(roomList[0].color!));
    } else {
      roomTabController.animation!.addListener(() {
        final int temp = roomTabController.animation!.value.round();
        if (activeIndex != temp) {
          activeIndex = temp;
          update(['tabIndicator']);
          playButtonColor(
              CustomColors.nameToRoomColor(roomList[activeIndex].color!));
          prefs.setInt('roomTabIndex', activeIndex);
          roomTabController.index = activeIndex;
          // print(activeIndex);
        }
      });
      prefs = await SharedPreferences.getInstance();
      // 이전에 저장된 탭 인덱스가 있는지 확인
      int? lastIndex = prefs.getInt('roomTabIndex');
      if (lastIndex != null) {
        roomTabController.index = lastIndex;
      }
    }
  }

  Future<void> _initOverlay() async {
    if (Platform.isAndroid) {
      overlayPermissionStatus =
          await FlutterOverlayWindow.isPermissionGranted();
      if (!overlayPermissionStatus) {
        await FlutterOverlayWindow.requestPermission();
      }
      _appLifecycleListener = AppLifecycleListener(
        onStateChange: _onLifecycleChanged,
      );
    }
  }

  void _onLifecycleChanged(AppLifecycleState state) async {
    if (isTimer.value) {
      switch (state) {
        case AppLifecycleState.inactive: //ios용
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
        case AppLifecycleState.paused:
          {
            // print('앱 종료됨');
            await FlutterOverlayWindow.showOverlay();
          }
        case AppLifecycleState.resumed:
          {
            // print('앱 다시 들어옴');
            await FlutterOverlayWindow.closeOverlay();
          }
      }
    }
  }

  //init

  Stream<List<RoomStreamModel>> roomListStream(String roomId) {
    return RoomStreamRepository().roomStreamListStream(roomId);
  }

  void arrangeSnapshot(
    AsyncSnapshot<List<RoomStreamModel>> snapshot,
    RoomModel roomModel,
  ) async {
    roomStreamList = snapshot.data!;
    liveRoomStreamList = List.from(roomStreamList);
    DateTime now = DateTime.now();
    // liveRoomStreamList에 대한 totalLiveSeconds 계산
    for (int i = 0; i < liveRoomStreamList.length; i++) {
      liveRoomStreamList[i] = LiveSecondsUtil().calcTotalLiveSecInRoomStream(
        liveRoomStreamList[i],
        now,
      );
      //4시간 이상 접속을 안했을 경우 sleepy 실행
      _checkSleepy(liveRoomStreamList[i]);
    }
    // totalLiveSeconds를 기준으로 리스트를 큰 순서대로 정렬
    liveRoomStreamList.sort(
      (a, b) => b.totalLiveSeconds!.compareTo(a.totalLiveSeconds!),
    );
  }

  void _checkSleepy(RoomStreamModel roomStreamModel) async {
    bool isSleepy = isTimeDifferenceMoreThanFourHours(
            roomStreamModel.lastTime, DateTime.now()) &&
        roomStreamModel.characterData!.actionState != 2 &&
        !roomStreamModel.isTimer!;
    if (isSleepy) {
      CharacterModel updatedCharacterModel =
          roomStreamModel.characterData!.copyWith(actionState: 2);
      //roomStreamModel 업데이트
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        characterData: updatedCharacterModel,
      );
      RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
      //userModel 업데이트
      UserModel? userModel =
          await UserRepository.getUserData(roomStreamModel.uid!);
      UserModel updatedUserModel = userModel!.copyWith(
        characterData: updatedCharacterModel,
      );
      UserRepository().updateUserModel(updatedUserModel);
    }
  }

  bool isTimeDifferenceMoreThanFourHours(
      DateTime? firstTime, DateTime secondTime) {
    // firstTime이 null이면 항상 참을 반환
    if (firstTime == null) {
      return true;
    }
    Duration difference = firstTime.difference(secondTime);
    return difference.abs() >= const Duration(hours: 4);
  }

  //button

  void startButton() async {
    DateTime now = DateTime.now();
    isTimer(true);

    //개인 StudyTimeModel 설정
    await _updateStudyTimeModelAtStart(now);

    //방별 roomStream 설정
    roomList.forEach(
      (RoomModel roomModel) async {
        RoomStreamModel roomStreamModel =
            await RoomStreamRepository().getRoomStream(
          roomModel.roomId!,
          AuthController.to.user.value.uid!,
        );
        CharacterModel updatedCharacterModel =
            roomStreamModel.characterData!.copyWith(
          actionState: 1,
        );
        RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
          isTimer: true,
          startTime: now,
          characterData: updatedCharacterModel,
        );
        if (roomModel.roomType == 'day') {
          updatedRoomStreamModel = updatedRoomStreamModel.copyWith(
            totalSeconds: AuthController.to.studyTime.totalSeconds,
          );
        }
        await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
      },
    );
  }

  Future _updateStudyTimeModelAtStart(DateTime now) async {
    //isTimer update
    UserModel updatedUserModel = AuthController.to.user.value.copyWith(
      isTimer: true,
    );
    AuthController.to.updateUserModel(updatedUserModel);
    //model update
    StudyTimeModel updatedStudyTimeModel = AuthController.to.studyTime.copyWith(
      startTime: now,
    );
    StudyTimeRepository().updateStudyTimeModel(updatedStudyTimeModel);
    AuthController.to.studyTime = updatedStudyTimeModel;
  }

  void stopButton() async {
    DateTime now = DateTime.now();
    int totalSecRoomStream = 0;

    isTimer(false);

    int diffSec = SecondsUtil.calculateDifferenceInSeconds(
      AuthController.to.studyTime.startTime!,
      now,
    );
    int totalSec = AuthController.to.studyTime.totalSeconds! + diffSec;

    //개인 studyTimeModel 업로드
    if (diffSec > LiveSecondsUtil.deletionCriteria) {
      //한번에 측정한 시간이 17시간을 초과했을경우 측정 시간 0으로 초기화
      openAlertDialog(
        title: '시간 초과',
        content: '한번에 측정한 시간이 17시간이 초과했습니다. 부정 시간 측정으로 간주하여 기록이 삭제됩니다.',
      );
      diffSec = 0;
    } else {
      await _updateStudyTimeModelAtEnd(now, totalSec);
    }
    HomePageController.to.totalTime(totalLiveTime.value);

    //방별 roomStream 설정
    roomList.forEach((RoomModel roomModel) async {
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        AuthController.to.user.value.uid!,
      );
      if (roomModel.roomType == 'day') {
        totalSecRoomStream = totalSec;
      } else {
        totalSecRoomStream = roomStreamModel.totalSeconds! + diffSec;
      }
      CharacterModel updatedCharacterModel =
          roomStreamModel.characterData!.copyWith(
        actionState: 0,
      );
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        isTimer: false,
        lastTime: now,
        totalSeconds: totalSecRoomStream,
        characterData: updatedCharacterModel,
      );
      await RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
      //졸린 상태라면 졸린 상태 멈추기
      if (AuthController.to.user.value.characterData!.actionState == 2) {
        AuthController.to.updateCharacterModel(
          updatedCharacterModel,
          AuthController.to.user.value,
        );
        HomePageController.to.riveCharacterInit();
      }
    });
  }

  Future<void> _updateStudyTimeModelAtEnd(DateTime now, int totalSec) async {
    //isTimer update
    UserModel updatedUserModel = AuthController.to.user.value.copyWith(
      isTimer: false,
    );
    AuthController.to.updateUserModel(updatedUserModel);
    //studyTime update
    StudyTimeModel studyTimeModel = AuthController.to.studyTime;
    if (DateUtil().calculateDateDifference(studyTimeModel.startTime!, now) >=
        1) {
      //시간 측정중 하루가 넘어감
      datePassed(now);
    } else {
      StudyTimeModel updatedStudyTimeModel =
          AuthController.to.studyTime.copyWith(
        lastTime: now,
        totalSeconds: totalSec,
      );
      StudyTimeRepository().uploadStudyTimeModel(updatedStudyTimeModel);
      AuthController.to.studyTime = updatedStudyTimeModel;
    }
  }

  Future<void> datePassed(DateTime now) async {
    //Todo: 만약 유저가 24시간 이상 타이머를 켜놓는다면 이슈 발생
    final fourAMToday = DateUtil.standardRefreshTime(now);
    StudyTimeModel previousTimeModel = AuthController.to.studyTime;
    // 전날 startTime부터 새벽 4시까지 공부한 분량 계산
    final previousDiffSec = SecondsUtil.calculateDifferenceInSeconds(
      previousTimeModel.startTime!,
      fourAMToday,
    );
    final previousTotalSec = previousTimeModel.totalSeconds! + previousDiffSec;
    // 전 date doc에 업데이트
    final previousUpdatedTimeModel = previousTimeModel.copyWith(
      lastTime: fourAMToday,
      totalSeconds: previousTotalSec,
    );
    await StudyTimeRepository().updateStudyTimeModel(previousUpdatedTimeModel);

    // 오늘자의 새벽 4시부터 lastTime까지의 seconds 차이 계산
    final todayDiffSec =
        SecondsUtil.calculateDifferenceInSeconds(fourAMToday, now);
    // 오늘자 date doc에 업데이트
    final todayUpdatedTimeModel = previousTimeModel.copyWith(
      date: DateUtil().dateTimeToString(now),
      createdAt: now,
      startTime: fourAMToday,
      lastTime: now,
      totalSeconds: todayDiffSec,
      isCashed: false,
    );
    await StudyTimeRepository().uploadStudyTimeModel(todayUpdatedTimeModel);
  }

  @override
  void onClose() {
    super.onClose();
    _secondsTimer.cancel();
    if (Platform.isAndroid) {
      _appLifecycleListener.dispose();
    }
  }
}
