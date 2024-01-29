import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/my/controllers/my_page_controller.dart';
import 'package:ggsb_project/src/features/setting/pages/setting_page.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      title: TitleText(
        text: 'My',
      ),
    );
  }

  Widget _profile() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${AuthController.to.user.value.nickname}님 \n안녕하세요 :)',
            style: TextStyle(
              color: CustomColors.blackText,
              fontSize: 24,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: CustomColors.lightGreyBackground,
          ),
        ),
      ],
    );
  }

  Widget _graphBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          //height 원래 20이였으나 임시로 10으로 바꿈
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '주간 공부시간',
                style: TextStyle(
                  color: CustomColors.greyText,
                  fontSize: 13,
                ),
              ),
              Text(
                '120:00:00',
                style: TextStyle(
                  color: CustomColors.blackText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _button(
          Image.asset(
            'assets/icons/my_data_analyze.png',
            width: 30,
            height: 30,
          ),
          '기록 분석',
          () {},
        ),
        SizedBox(height: 40),
        Container(
          color: CustomColors.lightGreyBackground,
          width: 100,
          height: 1,
        ),
        SizedBox(height: 40),
        _button(
          Image.asset(
            'assets/icons/my_settings.png',
            width: 30,
            height: 30,
          ),
          '설정',
          () {
            Get.to(SettingPage());
          },
        ),
        SizedBox(height: 10),
        _button(
          Image.asset(
            'assets/icons/my_report.png',
            width: 30,
            height: 30,
          ),
          '문의하기',
          () {},
        ),
      ],
    );
  }

  Widget _button(Widget icon, String text, VoidCallback onTap) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: CustomColors.whiteBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        height: 60,
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: CustomColors.blackText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MyPageController());
    return SafeArea(
      child: Scaffold(
          appBar: _appBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _profile(),
                  _graphBox(),
                  _buttons(),
                  SizedBox(height: 95),
                  //height원래 95였으나 에러로 85로 임시로 바꿈
                ],
              ),
            ),
          )),
    );
  }
}
