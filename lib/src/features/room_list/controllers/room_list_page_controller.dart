import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/amplitude_analytics.dart';
import 'package:ggsb_project/src/helpers/google_analytics.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';

class RoomListPageController extends GetxController {
  static RoomListPageController get to => Get.find();

  Rx<bool> isRoomListLoading = false.obs;
  Rx<bool> isNoRoomList = false.obs;

  Rx<String> saying = ''.obs;

  TextEditingController joinRoomIdController = TextEditingController();


  // void checkIsRoomList() {
  //   // await AuthController.to
  //   //     .updateAuthController(AuthController.to.user.value.uid!);
  //   isNoRoomList(AuthController.to.user.value.roomIdList == null ||
  //       AuthController.to.user.value.roomIdList!.isEmpty);
  // }

  Future<List<RoomModel>> getRoomList() async {
    // print('방리스트${AuthController.to.user.value.roomIdList}');
    if (AuthController.to.user.value.roomIdList!.isEmpty) {
      isNoRoomList(true);
      return [];
    } else {
      List<RoomModel> roomList = await RoomRepository()
          .getRoomList(AuthController.to.user.value.roomIdList!);
      // print('방 개수 ${roomList.length}');
      return roomList;
    }
  }

  // Future<void> getSaying() async {
  //   String apiUrl = ServiceUrls.sayingUrl;
  //   http.Response response = await http.get(Uri.parse(apiUrl));
  //
  //   if (response.statusCode == 200) {
  //     final responseByte =
  //         utf8.decode(response.bodyBytes, allowMalformed: true);
  //     final document = parser.parse(responseByte);
  //     final element = document.getElementsByTagName('p')[0].text;
  //     // print('명언 ${element}');
  //     saying(element.toString());
  //   } else {
  //     throw openAlertDialog(
  //         title: '명언 로드에 실패했습니다.',
  //         content: '에러코드: ${response.statusCode.toString()}');
  //   }
  // }

  Future<void> joinRoomButton() async {
    if (joinRoomIdController.text == '') {
      openAlertDialog(title: '방 초대 코드를 입력해주세요');
    } else if (AuthController.to.user.value.roomIdList!
        .contains(joinRoomIdController.text)) {
      //이미 해당 방에 들어가 있을 경우
      openAlertDialog(title: '가입 불가', content: '이미 가입되어 있는 방입니다.');
    } else {
      isRoomListLoading(true);
      RoomModel? roomModel =
          await RoomRepository().getRoomModel(joinRoomIdController.text);
      if (roomModel == null) {
        Get.back();
        openAlertDialog(title: '방 정보가 없습니다.');
        isRoomListLoading(false);
      } else if (roomModel.uidList!.length >= 7) {
        Get.back();
        openAlertDialog(title: '방이 가득 찼습니다.');
        isRoomListLoading(false);
      } else {
        //방 정보 업데이트
        RoomModel updatedRoomModel = roomModel.copyWith(
          uidList: [
            ...roomModel.uidList!,
            AuthController.to.user.value.uid!,
          ],
        );
        await RoomRepository().updateRoomModel(updatedRoomModel);
        //RoomStream업로드
        RoomStreamModel newRoomStreamModel = RoomStreamModel(
          uid: AuthController.to.user.value.uid,
          roomId: roomModel.roomId,
          nickname: AuthController.to.user.value.nickname,
          totalSeconds: AuthController.to.studyTime.totalSeconds,
          isTimer: false,
          startTime: DateTime.now(),
          lastTime: null,
          characterData: AuthController.to.user.value.characterData,
        );
        await RoomStreamRepository().uploadRoomStream(newRoomStreamModel);
        //유저 정보 업데이트
        UserModel userModel = AuthController.to.user.value;
        UserModel updatedUserModel = userModel.copyWith(
          roomIdList: userModel.roomIdList == null
              ? [joinRoomIdController.text]
              : [
                  ...userModel.roomIdList!,
                  joinRoomIdController.text,
                ],
        );
        await AuthController.to.updateUserModel(updatedUserModel);
        isNoRoomList(AuthController.to.user.value.roomIdList!.isEmpty);
        // checkIsRoomList();
        // joinRoomIdController.clear();
        GoogleAnalytics()
            .logEvent('join_room', {'room_owner': roomModel.creatorUid});
        AmplitudeAnalytics()
            .logEvent('join_room', {'room_owner': roomModel.creatorUid});
        Get.back();
        isRoomListLoading(false);
      }
    }
  }

}
