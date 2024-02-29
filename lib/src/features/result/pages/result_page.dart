import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/result/controllers/result_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:screenshot/screenshot.dart';

class ResultPage extends GetView<ResultPageController> {
  const ResultPage({super.key});

  Widget _backButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.back();
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: SvgPicture.asset('assets/images/caption_logo.svg'),
    );
  }

  Widget _resultBox() {
    return Expanded(
      child: TabBarView(
        controller: controller.roomTabController,
        children: _resultBoxList(),
      ),
    );
  }

  List<Widget> _resultBoxList() {
    return List.generate(controller.roomModelList.length, (roomIndex) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: CustomColors.whiteBackground,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                DateFormat('yyyy - MM - dd').format(DateUtil().getYesterday()),
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.greyText,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                controller.roomModelList[roomIndex]!.roomName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.blackText,
                ),
              ),
              FutureBuilder(
                future: controller.getStudyTimeList(roomIndex),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('오류 발생');
                  } else {
                    controller.firstUidList.add(snapshot.data![0]!.uid!);
                    return Column(
                      children: List.generate(
                        snapshot.data!.length,
                        (userIndex) {
                          return _timeCard(
                            snapshot.data![userIndex]!.uid!,
                            // snapshot.data![userIndex]!.nickname!,
                            SecondsUtil.convertToDigitString(
                                snapshot.data![userIndex]!.totalSeconds!),
                            SecondsUtil.convertToDigitString(
                                snapshot.data![userIndex]!.totalSeconds!),
                            userIndex,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _timeCard(String uid, String nickname, String time, int index) {
    return index == 0
        ? SizedBox(
            height: 320,
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: RiveAnimation.asset(
                    'assets/riv/character.riv',
                    stateMachines: ["character"],
                    onInit: (artboard) {
                      controller.onRiveInit(artboard, uid);
                    },
                  ),
                ),
                Image.asset('assets/icons/trophy.png', width: 20),
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.mainBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 30,
                    color: CustomColors.blackText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 50,
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: CustomColors.lightGreyBackground,
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 70,
            child: Column(
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.mainBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 20, color: CustomColors.greyText),
                ),
              ],
            ),
          );
  }

  Widget _tabIndicator() {
    return GetBuilder<ResultPageController>(
      id: 'tabIndicator',
      builder: (controller) {
        return Visibility(
          visible: controller.indicatorCount != 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.indicatorCount,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: controller.roomTabController.index == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: MainButton(
              onTap: () {
                controller.shareScreenButton();
              },
              icon: Image.asset(
                'assets/icons/insta_share.png',
                width: 25,
              ),
              buttonText: '공유',
              textStyle: const TextStyle(
                fontSize: 14,
                color: CustomColors.whiteText,
              ),
              backgroundColor: CustomColors.blackRoom,
              height: 70,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: MainButton(
              onTap: () {
                controller.saveImageButton();
              },
              icon: Image.asset(
                'assets/icons/download.png',
                width: 25,
              ),
              buttonText: '이미지 저장',
              textStyle: const TextStyle(
                color: CustomColors.blackText,
                fontSize: 14,
              ),
              backgroundColor: CustomColors.whiteBackground,
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResultPageController());
    return Obx(
      () => !controller.isPageLoading.value
          ? Scaffold(
              backgroundColor: CustomColors.mainBlue,
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Screenshot(
                            controller: controller.screenshotController,
                            child: Column(
                              children: [
                                _title(),
                                _resultBox(),
                              ],
                            ),
                          ),
                        ),
                        _tabIndicator(),
                        _shareButton(),
                      ],
                    ),
                    Positioned(
                      right: 20,
                      top: 10,
                      child: _backButton(),
                    ),
                  ],
                ),
              ),
            )
          : FullSizeLoadingIndicator(
              backgroundColor: CustomColors.mainBlue.withOpacity(0.5),
            ),
    );
  }
}
