import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/setting/controllers/setting_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/text_regular.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
            SizedBox(height: 20),
            _titlebox('고객지원'),
            SizedBox(height: 4),
            _button('리뷰 남기기', () {}, true, true),
            _linebox(),
            _button('앱 버전', () {}, false, true),
            _linebox(),
            _button('이용약관', () async {
              await controller.serviceTermsButton();
            }, true, true),
            SizedBox(height: 34),
            _titlebox('계정'),
            SizedBox(height: 20),
            _linebox(),
            _button('연결된 계정', () {
              controller.settingButton();
            }, true, true),
            _linebox(),
            _button('로그아웃', () {}, false, false),
            _linebox(),
          ],
        ),
        SizedBox(height: 32),
        _quitBox(),
      ],
    );
  }

  Widget _quitBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 47,
        decoration: BoxDecoration(
            color: CustomColors.subRed,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Center(
          child: Text(
            '탈퇴하기',
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  // VoidCallback onTap,
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
      iconWidget = SizedBox();
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

  Widget _linebox() {
    return Center(
      child: Container(
        width: 314,
        height: 1,
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
        ),
      ),
    );
  }

  Widget _titlebox(String text) {
    return Row(
      children: [
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
              color: CustomColors.blackText,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SettingPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buttons(),
            ],
          ),
        ),
      ),
    );
  }
}
