import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/setting/controllers/setting_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

final InAppReview inAppReview = InAppReview.instance;

class SettingPage extends GetView<SettingPageController> {
  const SettingPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      leading: SvgIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: Get.back,
      ),
      title: TitleText(
        text: '설정',
      ),
    );
  }

  Widget _buttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _title('고객지원'),
            const SizedBox(height: 4),
            _button('리뷰 남기기', () async {
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
            }, true, true),
            _divider(),
            Row(
              children: [
                Expanded(
                  child: _button('앱 버전', () {}, false, true),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final version = snapshot.data!.version;
                        return Text(
                          'v $version',
                          style: const TextStyle(
                              color: CustomColors.lightGreyText),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
            _divider(),
            _button('이용약관', () async {
              await controller.serviceTermsButton();
            }, true, true),
            const SizedBox(height: 34),
            _title('계정'),
            const SizedBox(height: 20),
            _divider(),
            _button('연결된 계정', () {
              Get.dialog(_settingDialog());
            }, true, true),
            _divider(),
            _button('로그아웃', () {
              controller.signOutButton();
            }, false, false),
            _divider(),
          ],
        ),
        const SizedBox(height: 32),
        _deleteUserButton(),
      ],
    );
  }

  Widget _deleteUserButton() {
    return CupertinoButton(
      onPressed: () {
        controller.deleteUserButton();
      },
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: CustomColors.subRed,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: const Center(
          child: Text(
            '탈퇴하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(
    String text,
    VoidCallback onPressed,
    bool hasIcon,
    bool isblackText,
  ) {
    Color textColor = isblackText ? CustomColors.blackText : Colors.red;
    Widget iconWidget;

    if (hasIcon) {
      iconWidget = SvgPicture.asset('assets/icons/back_right.svg');
    } else {
      iconWidget = const SizedBox();
    }

    return CupertinoButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  iconWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Center(
      child: Container(
        width: 314,
        height: 1,
        decoration: const BoxDecoration(
          color: CustomColors.lightGreyBackground,
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
              color: CustomColors.blackText,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }

  Widget _settingDialog() {
    String loginType = AuthController.to.user.value.loginType ?? '';
    Widget icon;

    switch (loginType) {
      case 'google':
        icon = Image.asset(
          'assets/icons/google.png',
          height: 30,
        );
        break;
      case 'facebook':
        icon = Image.asset(
          'assets/icons/facebook.png',
          height: 30,
        );
        break;
      case 'apple':
        icon = Image.asset(
          'assets/icons/apple.png',
          height: 30,
        );
        break;
      default:
        icon = const SizedBox(); // 기본값은 빈 위젯
        break;
    }

    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CustomColors.whiteBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back(); // 팝업 닫기
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  icon,
                  const SizedBox(width: 20),
                  Center(
                    child: Text(
                      AuthController.to.user.value.email ?? '',
                      style: const TextStyle(
                        color: CustomColors.blackText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ], // Column의 children 리스트 마감
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SettingPageController());
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buttons(),
      ),
    );
  }
}
