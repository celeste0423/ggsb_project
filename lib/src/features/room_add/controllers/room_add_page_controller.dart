import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:uuid/uuid.dart';

class RoomAddPageController extends GetxController {
  static RoomAddPageController get to => Get.find();
  Uuid uuid = Uuid();

  TextEditingController roomNameController = TextEditingController();

  Rx<bool> isPageLoading = false.obs;

  Rx<String> roomType = 'day'.obs;

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
    roomId(uuid.v4().toString().substring(0, 7));
  }

  void inviteCodeCopyButton() {
    Clipboard.setData(
      ClipboardData(text: roomId.value),
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

  Future<void> addRoomButton() async {
    if (roomNameController.text == '') {
      openAlertDialog(title: '방 이름을 입력해주세요');
    } else {
      isPageLoading(true);
      print('유저 컨트롤러 정보 ${AuthController.to.user.value.toJson()}');
      //방 모델 업로드
      RoomModel roomModel = RoomModel(
        roomId: roomId.value,
        roomName: roomNameController.text,
        creatorUid: AuthController.to.user.value.uid,
        creatorName: AuthController.to.user.value.nickname,
        roomType: roomType.value,
        color: CustomColors.roomColorToName(selectedColor.value),
        uidList: [
          AuthController.to.user.value.uid!,
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      RoomRepository().createRoom(roomModel);
      //roomStream 업로드
      RoomStreamModel newRoomStreamModel = RoomStreamModel(
        uid: AuthController.to.user.value.uid,
        roomId: roomId.value,
        nickname: AuthController.to.user.value.nickname,
        totalSeconds: AuthController.to.studyTime.totalSeconds,
        isTimer: false,
        startTime: DateTime.now(),
        lastTime: null,
        characterData: AuthController.to.user.value.characterData,
      );
      RoomStreamRepository().uploadRoomStream(newRoomStreamModel);
      //개인 데이터 업데이트
      UserModel userModel = AuthController.to.user.value;
      // print('룸 아이디 업데이트${roomId.value}');
      UserModel updatedUserModel = userModel.copyWith(
        roomIdList: userModel.roomIdList == null
            ? [roomId.value]
            : [
                ...userModel.roomIdList!,
                roomId.value,
              ],
      );
      UserRepository().updateUserModel(updatedUserModel);
      RoomListPageController().checkIsRoomList();
      Get.back();
    }
  }

  @override
  void onClose() {
    super.onClose();
    roomNameController.dispose();
  }
}
