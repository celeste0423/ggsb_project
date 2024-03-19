import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/result/controllers/result_page_controller.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:ggsb_project/src/utils/number_util.dart';
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
              controller.roomModelList[roomIndex].roomName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CustomColors.blackText,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: controller.getStudyTimeList(roomIndex),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('오류 발생');
                  } else {
                    print(snapshot.data!.length);
                    return _timeCardList(snapshot);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _timeCardList(AsyncSnapshot<List<StudyTimeModel?>> snapshot) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: (Get.height - 120 - 130 - 20) / 2 - 150,
                child: RiveAnimation.asset(
                  'assets/riv/character.riv',
                  stateMachines: const ["character"],
                  onInit: (artboard) {
                    controller.onRiveInit(artboard);
                  },
                ),
              ),
              Image.asset('assets/icons/trophy.png', height: 20),
              Text(
                AuthController.to.user.value.nickname!,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.mainBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                SecondsUtil.convertToDigitString(
                    controller.myStudyTime.totalSeconds ?? 0),
                style: const TextStyle(
                  fontSize: 20,
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
        ),
        Expanded(
          child: snapshot.data!.length == 1
              ? _timeCard(
                  AuthController.to.user.value.uid!,
                  AuthController.to.user.value.nickname!,
                  SecondsUtil.convertToDigitString(
                      snapshot.data![0]!.totalSeconds!),
                  0,
                )
              : GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  children: List.generate(
                    snapshot.data!.length,
                    (userIndex) {
                      return _timeCard(
                        snapshot.data![userIndex]!.uid!,
                        snapshot.data![userIndex]!.nickname!,
                        SecondsUtil.convertToDigitString(
                            snapshot.data![userIndex]!.totalSeconds!),
                        userIndex,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _timeCard(String uid, String nickname, String time, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              NumberUtil.toOrdinal(index + 1),
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.mainBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              nickname,
              style: TextStyle(
                fontSize: 14,
                color: uid == AuthController.to.user.value.uid
                    ? CustomColors.mainBlue
                    : CustomColors.mainBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            color: CustomColors.greyText,
          ),
        ),
      ],
    );
  }

  Widget _tabIndicator() {
    return GetBuilder<ResultPageController>(
      id: 'tabIndicator',
      builder: (controller) {
        return Visibility(
          visible: controller.indicatorCount != 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
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
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 30,
        top: controller.indicatorCount != 1 ? 0 : 30,
      ),
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
              height: 60,
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
              height: 60,
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
                        Column(
                          children: [
                            _tabIndicator(),
                            _shareButton(),
                          ],
                        ),
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
