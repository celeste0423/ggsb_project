import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/live_seconds_util.dart';

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

    _secondsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      update(['roomUserListTimer']);
    });
    Future.delayed(Duration(milliseconds: 100), () {
      backgroundAnimation(true);
    });
  }

  Future<void> deleteUser(RoomStreamModel roomStreamModel) async {
    //유저 정보에서 방리스트 삭제
    UserRepository.removeRoomId(roomStreamModel.uid!, roomStreamModel.roomId!);
    //roomStream 삭제
    RoomStreamRepository()
        .deleteRoomStream(roomStreamModel.roomId!, roomStreamModel.uid!);
    //roomModel에서 uid 삭제
    RoomRepository().removeUid(roomStreamModel.roomId!, roomStreamModel.uid!);
  }

  Stream<List<RoomStreamModel>> roomUserListStream() {
    return RoomStreamRepository().roomStreamListStream(roomModel.roomId!);
  }

  void arrangeSnapshot(AsyncSnapshot<List<RoomStreamModel>> snapshot) {
    roomStreamList = snapshot.data!;
    liveRoomStreamList = List.from(roomStreamList);
    // liveRoomStreamList에 대한 totalLiveSeconds 계산
    for (int i = 0; i < liveRoomStreamList.length; i++) {
      liveRoomStreamList[i] =
          LiveSecondsUtil.calcTotalLiveSecInRoomStream(liveRoomStreamList[i]);
    }
    // totalLiveSeconds를 기준으로 리스트를 큰 순서대로 정렬
    liveRoomStreamList
        .sort((a, b) => b.totalLiveSeconds!.compareTo(a.totalLiveSeconds!));
    // totalLiveSeconds가 0인 liveRoomStream을 찾아내서 맨 뒤로 이동시킴
    for (int i = 0; i < liveRoomStreamList.length; i++) {
      if (LiveSecondsUtil().whetherTimerZeroInInt(
              liveRoomStreamList[i], roomModel, DateTime.now()) ==
          0) {
        liveRoomStreamList.add(liveRoomStreamList.removeAt(i));
        // i--; // 리스트의 크기가 줄어들었으므로 다시 현재 인덱스로 돌아가서 확인해야 함
      }
    }
    // 정렬된 리스트의 첫 번째 요소의 totalLiveSeconds를 roomBestSeconds로 설정
    if (liveRoomStreamList.isNotEmpty) {
      roomBestSeconds = liveRoomStreamList.first.totalLiveSeconds!;
    }
  }

  Future<bool> backButton() async {
    RoomListPageController().checkIsRoomList();
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
        await deleteUser(roomStreamModel);
        RoomListPageController().checkIsRoomList();
        isPageLoading(false);
        Get.back();
      },
      secondfunction: () {
        Get.back();
      },
    );
  }

  void outOfRoomButton() {
    RoomStreamModel roomStreamModel = RoomStreamModel(
      uid: AuthController.to.user.value.uid,
      roomId: roomModel.roomId,
    );
    deleteUser(roomStreamModel);
    RoomListPageController().checkIsRoomList();
    Get.back();
  }

  void deleteRoomButton() {
    //모든 유저에 대해 roomId 삭제
    for (String uid in roomModel.uidList!) {
      UserRepository.removeRoomId(uid, roomModel.roomId!);
    }
    //roomModel 삭제
    RoomRepository().deleteRoomModel(roomModel);
    //방 리스트 새로고침
    RoomListPageController().checkIsRoomList();
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
