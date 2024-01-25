import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:uuid/uuid.dart';

class RoomAddPageController extends GetxController {
  static RoomAddPageController get to => Get.find();
  Uuid uuid = Uuid();

  TextEditingController roomNameController = TextEditingController();

  List<Color> colors = [
    CustomColors.redRoom,
    CustomColors.orangeRoom,
    CustomColors.yellowRoom,
    CustomColors.lightGreenRoom,
    CustomColors.greenRoom,
    CustomColors.darkGreenRoom,
    CustomColors.blueRoom,
    CustomColors.darkBlueRoom,
    CustomColors.purpleRoom,
    CustomColors.brownRoom,
    CustomColors.greyRoom,
    CustomColors.blackRoom,
  ];
  Rx<Color> selectedColor = CustomColors.redRoom.obs;

  void inviteCodeCopyButton() {
    Clipboard.setData(
      ClipboardData(text: '예시 코드'),
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

  Future<void> addRoomButton() async {
    print('방 생성 기능 구현');
  }
}
