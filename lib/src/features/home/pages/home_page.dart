import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SvgPicture.asset(
          'assets/images/caption_logo.svg',
          height: 25,
          color: CustomColors.mainBlack,
        ),
      ),
    );
  }

  Widget _charactorBox() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: CustomColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(150),
      ),
    );
  }

  Widget _buttonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MainButton(
              buttonText: '시간 측정',
              onTap: () {
                controller.timerPageButton();
              },
              icon: SvgPicture.asset(
                'assets/icons/play.svg',
                width: 20,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: MainButton(
              buttonText: '방 추가',
              textStyle: TextStyle(
                color: CustomColors.lightGreyText,
              ),
              backgroundColor: CustomColors.lightGreyBackground,
              onTap: () {
                controller.addRoomButton();
              },
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTab() {
    return Expanded(
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: CustomColors.mainBlack,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '오늘 누적 공부시간',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '00:01:52',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              controller.today.value,
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _charactorBox(),
            _buttonsRow(),
            _bottomTab(),
          ],
        ),
      ),
    );
  }
}
