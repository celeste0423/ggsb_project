import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/live_seconds_util.dart';
import 'package:rive/rive.dart';

class RoomDetailPageController extends GetxController {
  static RoomDetailPageController get to => Get.find();

  RoomModel roomModel = Get.arguments;
  late Timer _secondsTimer;
  Rx<bool> isPageLoading = false.obs;

  Rx<bool> backgroundAnimation = false.obs;

  List<RoomStreamModel> roomStreamList = [];
  List<RoomStreamModel> liveRoomStreamList = [];
  int roomBestSeconds = 0;

  // int roomTotalSeconds = 0;

  @override
  void onInit() async {
    super.onInit();
    _secondsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      update(['roomUserListTimer']);
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      backgroundAnimation(true);
    });
  }

  Future<RiveFile> getRiveFile() async {
    return await RiveFile.asset('assets/riv/character.riv');
  }

  Future<void> deleteUser(RoomStreamModel roomStreamModel) async {
    //유저 정보에서 방리스트 삭제
    await UserRepository.removeRoomId(
        roomStreamModel.uid!, roomStreamModel.roomId!);
    //roomStream 삭제
    await RoomStreamRepository()
        .deleteRoomStream(roomStreamModel.roomId!, roomStreamModel.uid!);
    //roomModel에서 uid 삭제
    await RoomRepository()
        .removeUid(roomStreamModel.roomId!, roomStreamModel.uid!);
  }

  Stream<List<RoomStreamModel>> roomUserListStream() {
    return RoomStreamRepository().roomStreamListStream(roomModel.roomId!);
  }

  void arrangeSnapshot(AsyncSnapshot<List<RoomStreamModel>> snapshot) async {
    roomStreamList = snapshot.data!;
    liveRoomStreamList = List.from(roomStreamList);
    DateTime now = DateTime.now();
    // liveRoomStreamList에 대한 totalLiveSeconds 계산
    for (int i = 0; i < liveRoomStreamList.length; i++) {
      liveRoomStreamList[i] = LiveSecondsUtil()
          .calcTotalLiveSecInRoomStream(liveRoomStreamList[i], now);
    }
    // totalLiveSeconds를 기준으로 리스트를 큰 순서대로 정렬
    liveRoomStreamList
        .sort((a, b) => b.totalLiveSeconds!.compareTo(a.totalLiveSeconds!));
    // 정렬된 리스트의 첫 번째 요소의 totalLiveSeconds를 roomBestSeconds로 설정
    if (liveRoomStreamList.isNotEmpty) {
      roomBestSeconds = liveRoomStreamList.first.totalLiveSeconds!;
    }
  }

  Future<bool> backButton() async {
    // RoomListPageController().checkIsRoomList();
    Get.back();
    return true; // 뒤로 가기를 허용할지 여부를 반환
  }

  void deleteUserButton(RoomStreamModel roomStreamModel) {
    openAlertDialog(
      title: '유저 삭제',
      content: '해당 유저를 방에서 내보내시겠습니까?',
      btnText: '내보내기',
      mainBtnColor: CustomColors.redText,
      secondButtonText: '취소',
      mainfunction: () async {
        isPageLoading(true);
        if (!roomStreamModel.isTimer!) {
          await deleteUser(roomStreamModel);
          // RoomListPageController().checkIsRoomList();
          Get.back();
        } else {
          Get.back();
          openAlertDialog(
            title: '내보낼 수 없음',
            content: '해당 유저는 현재 타이머가 실행중입니다.',
          );
        }
        isPageLoading(false);
      },
    );
  }

  void outOfRoomButton() async {
    RoomStreamModel roomStreamModel = RoomStreamModel(
      uid: AuthController.to.user.value.uid,
      roomId: roomModel.roomId,
    );
    await deleteUser(roomStreamModel);
    // RoomListPageController().checkIsRoomList();
    AuthController.to.updateLocalUserModel();
    // Get.offAll(const App());
    Get.back();
  }

  void deleteRoomButton() async {
    //모든 유저에 대해 roomId 삭제
    for (String uid in roomModel.uidList!) {
      UserRepository.removeRoomId(uid, roomModel.roomId!);
    }
    //roomModel 삭제
    RoomRepository().deleteRoomModel(roomModel);
    //유저 정보 반영
    AuthController.to.updateLocalUserModel();
    // Get.offAll(const App());
    Get.back();
  }

  void inviteCodeCopyButton() {
    Clipboard.setData(
      ClipboardData(text: roomModel.roomId!),
    ).then(
      (_) {
        openAlertDialog(
          title: '방 초대 코드가 복사되었습니다.',
          content: '친구들에게 코드를 보내주세요!',
          mainfunction: () {
            Get.back();
          },
        );
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    _secondsTimer.cancel();
  }
}
