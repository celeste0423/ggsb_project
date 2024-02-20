import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageController extends GetxController {
  static SettingPageController get to => Get.find();

  Future<void> deleteRoom(RoomModel roomModel) async {
    if (roomModel.creatorUid! == AuthController.to.user.value.uid) {
      //모든 유저에 대해 roomId 삭제
      for (String uid in roomModel.uidList!) {
        UserRepository.removeRoomId(uid, roomModel.roomId!);
      }
      //roomModel 삭제
      RoomRepository().deleteRoomModel(roomModel);
    } else {
      //roomStream 삭제
      RoomStreamRepository().deleteRoomStream(
          roomModel.roomId!, AuthController.to.user.value.uid!);
      //roomModel에서 uid 삭제
      RoomRepository()
          .removeUid(roomModel.roomId!, AuthController.to.user.value.uid!);
    }
  }

  Future<void> serviceTermsButton() async {
    Uri uri = Uri.parse(ServiceUrls.serviceTermsNotionUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openAlertDialog(title: '링크를 열 수 없습니다.');
    }
  }

  void signOutButton() {
    openAlertDialog(
      title: '로그아웃 하시겠습니까?',
      btnText: '로그아웃',
      mainBtnColor: CustomColors.subRed,
      secondButtonText: '취소',
      mainfunction: () async {
        await UserRepository.signOut();
        // Get.delete<AuthController>(force: true);
        // //todo: get.back 이거 왜 2개 있는거고 애초에 갯백이 필요한가? root에 있는 streambuilder있는데... screeen stack을 없애려고 하는건가
        Get.back();
        Get.back();
        Restart.restartApp();
        // Get.put(AuthController(), permanent: true);
        // exit(0);
      },
    );
  }

  void deleteUserButton() {
    openAlertDialog(
      title: '회원을 탈퇴하시겠습니까?',
      content: '정보는 복구될 수 없습니다.',
      btnText: '탈퇴하기',
      mainBtnColor: CustomColors.subRed,
      secondButtonText: '취소',
      mainfunction: () async {
        //만든방 전부 삭제(room, roomStream) , 들어가 있는 방에서 uid 삭제(room, roomStream)
        List<RoomModel> userRoomList = await RoomRepository()
            .getRoomList(AuthController.to.user.value.roomIdList!);
        for (RoomModel roomModel in userRoomList) {
          await deleteRoom(roomModel);
        }
        //user데이터 삭제(user, time)
        await UserRepository().deleteUserModel(AuthController.to.user.value);
        //sns 로그 아웃
        await UserRepository.signOut();
        //앱 종료
        Restart.restartApp();
        // Get.back();
        // Get.back();
        // exit(0);
      },
    );
  }
}
