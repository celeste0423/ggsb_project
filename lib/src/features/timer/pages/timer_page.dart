import 'package:animate_icons/animate_icons.dart' as animate_icon;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/timer/controllers/timer_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/live_seconds_util.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:ggsb_project/src/widgets/character_list.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';

class TimerPage extends GetView<TimerPageController> {
  const TimerPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: CustomColors.mainBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      leadingWidth: 75,
      title: Text(
        controller.today.value,
        style: const TextStyle(
          color: CustomColors.lightGreyText,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: Obx(
        () => Visibility(
          visible: !controller.isTimer.value,
          child: ImageIconButton(
            assetPath: 'assets/icons/back.svg',
            onTap: () {
              Get.back();
              // MethodChannel('flutter_screentime').invokeMethod('selectAppsToDiscourage');
            },
          ),
        ),
      ),
    );
  }

  Widget _map() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 300,
      width: 300,
      child: Obx(
        () {
          return controller.noRooms.value
              ? const Center(
                  child: Text(
                    '공검승부',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : controller.isPageLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : TabBarView(
                      controller: controller.roomTabController,
                      children: _mapList(),
                    );
        },
      ),
    );
  }

  List<Widget> _mapList() {
    return controller.roomList.map((RoomModel roomModel) {
      return StreamBuilder(
        stream: controller.roomListStream(roomModel.roomId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('불러오는 중 에러가 발생했습니다.');
          } else {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColors.lightGreyBackground,
              ),
              child: CharacterList(
                roomStreamList: controller.roomStreamList,
              ),
            );
          }
        },
      );
    }).toList();
  }

  Widget _time() {
    return Obx(
      () => AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 500),
        style: TextStyle(
          color: controller.isTimer.value
              ? controller.playButtonColor.value
              : Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.w800,
          fontFamily: 'nanum',
        ),
        child: Text(
          controller.totalLiveTime.value,
        ),
      ),
    );
  }

  Widget _playButton() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: controller.isTimer.value
              ? CustomColors.greyBackground
              : controller.playButtonColor.value,
        ),
        child: animate_icon.AnimateIcons(
          duration: const Duration(milliseconds: 200),
          startIcon: Icons.play_arrow_rounded,
          endIcon: Icons.pause,
          size: 45,
          controller: controller.animateIconController,
          onStartIconPress: () {
            controller.startButton();
            return true;
          },
          onEndIconPress: () {
            controller.stopButton();
            return true;
          },
          startIconColor: Colors.white,
          endIconColor: Colors.white,
        ),
      ),
    );
  }

  Widget _roomTabView() {
    return Expanded(
      child: Obx(
        () {
          return controller.noRooms.value
              ? const Center(
                  child: Text(
                    '방을 만들거나 방에 가입해보세요',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : controller.isPageLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : TabBarView(
                      controller: controller.roomTabController,
                      children: _roomList(),
                    );
        },
      ),
    );
  }

  List<Widget> _roomList() {
    return controller.roomList.map((RoomModel roomModel) {
      return StreamBuilder(
        stream: controller.roomListStream(roomModel.roomId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('불러오는 중 에러가 발생했습니다.');
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  roomModel.roomName!,
                  style: const TextStyle(
                    color: CustomColors.lightGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: GetBuilder<TimerPageController>(
                    id: 'roomListTimer',
                    builder: (controller) {
                      controller.arrangeSnapshot(snapshot, roomModel);
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            controller.roomStreamList.length,
                            (index) {
                              return _rankingCard(index, roomModel);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      );
    }).toList();
  }

  Widget _rankingCard(int index, RoomModel roomModel) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: index == 0 ? 30 : 60,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: controller.liveRoomStreamList[index].uid ==
                  AuthController.to.user.value.uid
              ? CustomColors.nameToRoomColor(roomModel.color!)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.toOrdinal(index + 1),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: index == 0 ? 24 : 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              controller.liveRoomStreamList[index].nickname!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                fontSize: index == 0 ? 20 : 16,
              ),
            ),
          ),
          Text(
            // SecondsUtil.convertToDigitString(
            //     controller.liveRoomStreamList[index].totalLiveSeconds!),
            SecondsUtil.convertToDigitString(
              LiveSecondsUtil().whetherTimerZeroInInt(
                controller.liveRoomStreamList[index],
                roomModel,
                DateTime.now(),
              ),
            ),
            style: TextStyle(
              color: controller.liveRoomStreamList[index].isTimer!
                  ? CustomColors.nameToRoomColor(roomModel.color!)
                  : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: index == 0 ? 20 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabIndicator() {
    return GetBuilder<TimerPageController>(
      id: 'tabIndicator',
      builder: (controller) {
        return Visibility(
          visible: controller.indicatorCount != 1,
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
        );
      },
    );
  }

  Widget _background() {
    return Positioned(
      bottom: 0,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          height: controller.isTimer.value ? Get.height : Get.height - 445,
          width: Get.width,
          decoration: BoxDecoration(
            color: CustomColors.mainBlack,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(controller.isTimer.value ? 0 : 50),
              topLeft: Radius.circular(controller.isTimer.value ? 0 : 50),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TimerPageController());
    return WillPopScope(
      onWillPop: () {
        if (controller.isTimer.value) {
          openAlertDialog(title: '타이머를 멈추고 나가주세요');
        } else {
          Get.back();
        }
        return Future(() => false);
      },
      child: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _appBar(),
            body: SizedBox(
              height: Get.height,
              child: Stack(
                children: [
                  _background(),
                  SafeArea(
                    child: SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Column(
                        children: [
                          _map(),
                          _playButton(),
                          const SizedBox(height: 10),
                          _time(),
                          const SizedBox(height: 10),
                          _roomTabView(),
                          _tabIndicator(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.isPageLoading.value,
              child: FullSizeLoadingIndicator(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
