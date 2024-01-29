import 'dart:async';

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

class RoomDetailPageController extends GetxController {
  static RoomDetailPageController get to => Get.find();

  RoomModel roomModel = Get.arguments;
  late Timer _secondsTimer;
  Rx<bool> isPageLoading = false.obs;

  Rx<bool> backgroundAnimation = false.obs;

  // Rx<int> roomTotalSeconds = 0.obs;
  Rx<int> roomBestSeconds = 0.obs;

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
    RoomStreamRepository().deleteRoomStream(roomStreamModel);
    //roomModel에서 uid 삭제
    RoomRepository().removeUid(roomStreamModel.roomId!, roomStreamModel.uid!);
  }

  Stream<List<RoomStreamModel>> roomUserListStream() {
    return RoomStreamRepository().roomListStream(roomModel.roomId!);
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

  void getOutButton() {
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
