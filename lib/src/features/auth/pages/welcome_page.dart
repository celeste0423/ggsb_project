import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/welcome_page_controller.dart';
import 'package:ggsb_project/src/features/auth/widgets/apple_login_button.dart';
import 'package:ggsb_project/src/features/auth/widgets/facebook_login_button.dart';
import 'package:ggsb_project/src/features/auth/widgets/google_login_button.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends GetView<WelcomePageController> {
  const WelcomePage({super.key});

  Widget _backgroundLogo() {
    return SvgPicture.asset(
      'assets/images/background_logo.svg',
      width: Get.width,
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 10),
          SvgPicture.asset(
            'assets/images/caption.svg',
            width: 175,
            height: 45,
          ),
          const SizedBox(height: 10),
          const Text(
            '공부로 대결하는\n한판 진검승부',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTab() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            const GoogleLoginButton(),
            const SizedBox(height: 10),
            const FacebookLoginButton(),
            const SizedBox(height: 10),
            AppleLoginButton(),
            const SizedBox(height: 10),
            _customLoginButton(),
            const SizedBox(height: 40),
            _infoText(),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget _customLoginButton() {
    return GestureDetector(
      onTap: () {
        Get.dialog(_registerDialog());
      },
      child: const Text(
        '게스트로 로그인',
        style: TextStyle(
          fontSize: 12,
          color: CustomColors.greyText,
        ),
      ),
    );
  }

  Widget _registerDialog() {
    return Dialog(
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            TextField(
              controller: controller.guestEmailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: controller.guestPasswordController,
              decoration: const InputDecoration(labelText: '비밀번호(6자리 이상)'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                controller.guestLogin();
              },
              child: const Text('회원가입 또는 로그인'),
            ),
            const SizedBox(height: 10),
            const Text(
              '(주의) 이메일과 비밀번호를 분실하신 경우에는 계정을 새로 만드셔야 합니다.\n비밀번호는 6자리 이상이어야합니다.',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: CustomColors.greyText,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: '이용약관 ',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Uri uri = Uri.parse(ServiceUrls.serviceTermsNotionUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      openAlertDialog(title: '오류 발생');
                    }
                  },
              ),
              const TextSpan(text: '및 '),
              TextSpan(
                text: '공지사항',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Uri uri = Uri.parse(ServiceUrls.noticeNotionUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      openAlertDialog(title: '오류 발생');
                    }
                  },
              ),
              const TextSpan(text: '을 클릭하여 확인하세요'),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FutureBuilder<String>(
          future: controller.getVersionInfo(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final version = snapshot.data!;
                return Text(
                  'v $version',
                  style: const TextStyle(
                    color: CustomColors.darkGreyText,
                    fontSize: 10,
                  ),
                );
              } else {
                // Future가 데이터를 가져오지 못한 경우에 대한 처리를 할 수 있습니다.
                return const Text('오류 : 버전정보를 가져올 수 없습니다.');
              }
            } else {
              return const Text('Unknown error');
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Get.put(WelcomePageController());
    return Scaffold(
      backgroundColor: CustomColors.mainBlue,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              _backgroundLogo(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _title(),
              ),
              _bottomTab()
            ],
          ),
        ],
      ),
    );
  }
}
