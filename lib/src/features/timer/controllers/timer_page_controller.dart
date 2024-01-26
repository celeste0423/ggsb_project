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

  late List<RoomModel> roomList;
  late TabController roomTabController;
  Rx<bool> noRooms = false.obs;

  final Rx<String> today =
      DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  @override
  void onInit() async {
    super.onInit();

    await getRoomList();
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
    isPageLoading(false);
  }

  Stream<List<RoomStreamModel>> roomListStream(String roomId) {
    return RoomStreamRepository().roomListStream(roomId);
  }

  Future<void> timerButton() async {
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
  }
}
