import 'package:animate_icons/animate_icons.dart' as animateIcon;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/features/timer/controllers/timer_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/calcTotalLiveSeconds.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';

class TimerPage extends GetView<TimerPageController> {
  const TimerPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarIconBrightness: Brightness.dark,
      // ),
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
          child: SvgIconButton(
            assetPath: 'assets/icons/back.svg',
            onTap: () {
              Get.back();
            },
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Column(
        children: [
          SizedBox(height: 75 + MediaQuery.of(Get.context!).padding.top),
          _map(),
          _time(),
          _playButton(),
          SizedBox(height: 20),
          _roomTabView(),
          _tabIndicator(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _map() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CustomColors.lightGreyBackground,
      ),
    );
  }

  Widget _time() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Obx(
        () => Text(
          controller.totalLiveTime.value,
          style: TextStyle(
            color:
                controller.isTimer.value ? CustomColors.mainBlue : Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _playButton() {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: controller.isTimer.value
              ? CustomColors.greyBackground
              : CustomColors.mainBlue,
        ),
        child: animateIcon.AnimateIcons(
          duration: Duration(milliseconds: 200),
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
      child: Obx(() {
        return controller.noRooms.value
            ? const Center(
                child: Text(
                  '방을 만들거나 방에 가입해보세요',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : controller.isPageLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.mainBlue,
                    ),
                  )
                : TabBarView(
                    controller: controller.roomTabController,
                    children: _roomList(),
                  );
      }),
    );
  }

  List<Widget> _roomList() {
    return controller.roomList.map((RoomModel roomModel) {
      return StreamBuilder(
        stream: controller.roomListStream(roomModel.roomId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.mainBlue,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('불러오는 중 에러가 발생했습니다.');
          } else {
            List<RoomStreamModel> roomStreamList = snapshot.data!;
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
                GetBuilder<TimerPageController>(
                  id: 'roomListTimer',
                  builder: (controller) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: roomStreamList.length,
                        itemBuilder: (context, index) {
                          return _rankingCard(
                            index,
                            roomStreamList[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      );
    }).toList();
  }

  Widget _rankingCard(int index, RoomStreamModel roomStreamModel) {
    RoomStreamModel liveRoomStreamModel =
        CalcTotalLiveSeconds.calcTotalLiveSecInRoomStream(roomStreamModel);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: index == 0 ? 50 : 80,
        vertical: 10,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                roomStreamModel.nickname!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400,
                  fontSize: index == 0 ? 20 : 16,
                ),
              ),
            ),
            Text(
              SecondsUtil.convertToDigitString(
                  liveRoomStreamModel.totalLiveSeconds!),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: index == 0 ? 20 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabIndicator() {
    return GetBuilder<TimerPageController>(
      id: 'tabIndicator',
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.indicatorCount.value,
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
        );
      },
    );
  }

  Widget _background() {
    return Positioned(
      bottom: 0,
      child: Obx(
        () => AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          height: controller.isTimer.value ? Get.height : Get.height - 395,
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
                  _content(),
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
