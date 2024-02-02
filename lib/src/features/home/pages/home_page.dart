import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:rive/rive.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: CustomColors.mainBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
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

  Widget _characterBox() {
    return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.circular(150),
        ),
        child: RiveAnimation.asset(
          'assets/icons/character.riv',
          stateMachines: ["idleState"],
          onInit: (_) {},
        ));
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
          const SizedBox(width: 20),
          Expanded(
            child: MainButton(
              buttonText: '방 생성',
              textStyle: const TextStyle(
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
        decoration: const BoxDecoration(
          color: CustomColors.mainBlack,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '오늘 누적 공부시간',
              style: TextStyle(
                color: CustomColors.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Obx(
              () => Text(
                // '${controller.totalHours}:${controller.totalMinutes}:${controller.totalSeconds}',
                controller.totalTime.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              controller.today.value,
              style: const TextStyle(
                color: CustomColors.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 85),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return Scaffold(
      extendBody: true,
      appBar: _appBar(),
      body: Column(
        children: [
          _characterBox(),
          _buttonsRow(),
          _bottomTab(),
        ],
      ),
    );
  }
}
