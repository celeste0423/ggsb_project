import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';

class RoomDetailPageController extends GetxController {
  static RoomDetailPageController get to => Get.find();

  RoomModel roomModel = Get.arguments;
  late Timer _secondsTimer;

  Rx<bool> backgroundAnimation = false.obs;

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

  Stream<List<RoomStreamModel>> roomUserListStream() {
    return RoomStreamRepository().roomListStream(roomModel.roomId!);
  }

  void inviteCodeCopyButton() {
    Clipboard.setData(
      ClipboardData(text: roomModel.roomId!),
    ).then(
      (_) {
        Get.snackbar(
          '방 초대 코드가 복사되었습니다.',
          '친구들에게 코드를 보내주세요!',
          snackPosition: SnackPosition.TOP,
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
