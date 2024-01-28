import 'dart:async';

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

  @override
  void dispose() {
    super.dispose();
    _secondsTimer.cancel();
  }
}
