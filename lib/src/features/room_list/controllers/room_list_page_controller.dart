import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';

class RoomListPageController extends GetxController {
  static RoomListPageController get to => Get.find();

  Rx<bool> isRoomList = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIsRoomList();
  }

  void _checkIsRoomList() {
    isRoomList(AuthController.to.user.value.roomIdList == null);
  }

  Future<List<RoomModel>> getRoomList() async {
    //유저 정보 업데이트
    await AuthController.to.loginUser(AuthController.to.user.value.uid!);
    List<RoomModel> roomList = await RoomRepository()
        .getRoomList(AuthController.to.user.value.roomIdList!);
    return roomList;
  }
}
