import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPageController extends GetxController {
  static SettingPageController get to => Get.find();

  void settingButton() {
    openAlertDialog(
      title: '방 초대 코드가 복사되었습니다.',
      // content: '친구들에게 코드를 보내주세요!',
      mainfunction: () {
        Get.back();
      },
    );
  }


  void settingButton2() {

    if( AuthController.to.user.value.loginType == 'google'){
      openAlertDialog(
        title: '방 초대 코드가 복사되었습니다.',
        // content: '친구들에게 코드를 보내주세요!',
        mainfunction: () {
          Get.back();
        },
      );
    }

    else if ( AuthController.to.user.value.loginType == 'facebook'){
      openAlertDialog(
        title: '방 초대 코드가 복사되었습니다.',
        // content: '친구들에게 코드를 보내주세요!',
        mainfunction: () {
          Get.back();
        },
      );
    }

  }


   Future<void> serviceTermsButton() async {

       Uri uri = Uri.parse(ServiceUrls.serviceTermsNotionUrl);
       if (await canLaunchUrl(uri)) {
         await launchUrl(uri);
       } else {
         openAlertDialog(title: '오류 발생');
       }
   }



}
