import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';

class RoomListPageController extends GetxController {
  static RoomListPageController get to => Get.find();

  Rx<bool> isRoomListLoading = false.obs;
  Rx<bool> isRoomList = false.obs;

  TextEditingController joinRoomIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkIsRoomList();
  }

  void _checkIsRoomList() async {
    isRoomListLoading(true);
    await AuthController.to
        .updateAuthController(AuthController.to.user.value.uid!);
    isRoomList(AuthController.to.user.value.roomIdList != null);
    isRoomListLoading(false);
  }

  Future<List<RoomModel>> getRoomList() async {
    //유저 정보 업데이트
    List<RoomModel> roomList = await RoomRepository()
        .getRoomList(AuthController.to.user.value.roomIdList!);
    print('방 개수 ${roomList.length}');
    return roomList;
  }

  Future<void> joinRoomButton() async {
    if (joinRoomIdController.text == '') {
      openAlertDialog(title: '방 초대 코드를 입력해주세요');
    } else {
      isRoomListLoading(true);
      //방 정보 업데이트
      RoomModel? roomModel =
          await RoomRepository().getRoomModel(joinRoomIdController.text!);
      if (roomModel == null) {
        Get.back();
        openAlertDialog(title: '방 정보가 없습니다.');
        isRoomListLoading(false);
      } else {
        RoomModel updatedRoomModel = roomModel.copyWith(
          uidList: [
            ...roomModel.uidList!,
            AuthController.to.user.value.uid!,
          ],
        );
        RoomRepository().updateRoomModel(updatedRoomModel);
        //유저 정보 업데이트
        await AuthController.to
            .updateAuthController(AuthController.to.user.value.uid!);
        isRoomList(AuthController.to.user.value.roomIdList != null);
        UserModel userModel = AuthController.to.user.value;
        UserModel updatedUserModel = userModel.copyWith(
          roomIdList: userModel.roomIdList == null
              ? [joinRoomIdController.text]
              : [
                  ...userModel.roomIdList!,
                  joinRoomIdController.text,
                ],
        );
        UserRepository().updateUserModel(updatedUserModel);
        InitBinding().refreshControllers();
        Get.back();
        joinRoomIdController.dispose();
        isRoomListLoading(false);
      }
    }
  }
}
