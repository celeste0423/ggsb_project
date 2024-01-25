import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:uuid/uuid.dart';

class RoomAddPageController extends GetxController {
  static RoomAddPageController get to => Get.find();
  Uuid uuid = Uuid();

  TextEditingController roomNameController = TextEditingController();

  Rx<bool> isRoomAddLoading = false.obs;

  Rx<bool> isRoomTypeDrop = false.obs;
  Rx<bool> isRoomType = false.obs;
  Rx<String> roomType = ''.obs;

  Rx<String> roomId = ''.obs;

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

  @override
  void onInit() {
    super.onInit();

    setRoomId();
  }

  void setRoomId() {
    roomId(uuid.v4().toString().substring(0, 18));
  }

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
    isRoomAddLoading(true);
    //룸 모델 업로드
    if (roomNameController.text == '') {
      isRoomAddLoading(false);
      openAlertDialog(title: '방 이름을 입력해주세요');
    } else if (roomType.value == null) {
      isRoomAddLoading(false);
      openAlertDialog(title: '경쟁 주기를 설정해주세요');
    } else {
      RoomModel roomModel = RoomModel(
        roomId: roomId.value,
        creatorUid: AuthController.to.user.value.uid,
        roomType: roomType.value,
        color: CustomColors.roomColorToName(selectedColor.value),
        uidList: [
          AuthController.to.user.value.uid!,
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      RoomRepository.createRoom(roomModel);
      //개인 데이터 업데이트
      UserModel updatedUserModel = AuthController.to.user.value;
      updatedUserModel.copyWith(
          roomIdList: updatedUserModel.roomIdList == null
              ? [roomId.value]
              : [
                  ...updatedUserModel.roomIdList!,
                  roomId.value,
                ]);
      Get.back();
    }
  }

  @override
  void dispose() {
    roomNameController.dispose();
    super.dispose();
  }
}
