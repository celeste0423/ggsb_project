import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_detail/controllers/room_detail_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomDetailPage extends GetView<RoomDetailPageController> {
  const RoomDetailPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      title: Column(
        children: [
          TitleText(
            text: controller.roomModel.roomName!,
            color: Colors.white,
          ),
          Text(
            '${controller.roomModel.uidList!.length}/6명 ${controller.roomModel.creatorName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      leading: Align(
        alignment: Alignment.centerRight,
        child: ImageIconButton(
          assetPath: 'assets/icons/back.svg',
          iconColor: Colors.white,
          onTap: () {
            controller.backButton();
          },
        ),
      ),
      actions: [
        controller.roomModel.creatorUid == AuthController.to.user.value.uid
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.deleteRoomButton();
                },
                child: const Text(
                  '방 삭제',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.outOfRoomButton();
                },
                child: const Text(
                  '방 나가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        const SizedBox(width: 30),
      ],
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 105),
          Expanded(
            child: StreamBuilder(
              stream: controller.roomUserListStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('불러오는 중 에러가 발생했습니다.');
                } else {
                  return GetBuilder<RoomDetailPageController>(
                    id: 'roomUserListTimer',
                    builder: (controller) {
                      controller.arrangeSnapshot(snapshot);
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                        itemCount: controller.roomStreamList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              height: Get.width - 60,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              // child: CharacterList(
                              //   roomStreamList: controller.liveRoomStreamList,
                              // ),
                            );
                          } else {
                            return _rankingCard(index - 1);
                          }
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankingCard(int index) {
    double percent =
        controller.liveRoomStreamList[index].totalLiveSeconds != null
            ? controller.roomBestSeconds != 0
                ? controller.liveRoomStreamList[index].totalLiveSeconds! /
                    (controller.roomBestSeconds).toDouble()
                : 0
            : 0;
    return Stack(
      children: [
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.liveRoomStreamList[index].nickname!,
                    style: TextStyle(
                      color: CustomColors.nameToRoomColor(
                          controller.roomModel.color!),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    SecondsUtil.convertToDigitString(
                      controller.liveRoomStreamList[index].totalLiveSeconds!,
                    ),
                    style: TextStyle(
                      color: controller.liveRoomStreamList[index].isTimer!
                          ? CustomColors.nameToRoomColor(
                              controller.roomModel.color!)
                          : CustomColors.blackText,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      color: CustomColors.lightGreyBackground,
                      strokeWidth: 8,
                      value: 1,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      color: CustomColors.nameToRoomColor(
                          controller.roomModel.color!),
                      strokeCap: StrokeCap.round,
                      strokeWidth: 8,
                      value: percent,
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 25,
                    child: Text(
                      '${(percent * 100).toInt()}%',
                      style: const TextStyle(
                        color: CustomColors.lightGreyText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Visibility(
            visible: controller.roomModel.creatorUid ==
                    AuthController.to.user.value.uid &&
                controller.liveRoomStreamList[index].uid !=
                    AuthController.to.user.value.uid,
            child: ImageIconButton(
              assetPath: 'assets/icons/cancel.svg',
              onTap: () {
                controller
                    .deleteUserButton(controller.liveRoomStreamList[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _background() {
    return Positioned(
      top: 0,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          height: controller.backgroundAnimation.value ? 275 : 0,
          width: Get.width,
          decoration: BoxDecoration(
            color: CustomColors.nameToRoomColor(controller.roomModel.color!),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _copyCodeButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.inviteCodeCopyButton();
      },
      child: Container(
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '초대 코드 복사 (${controller.roomModel.roomId!})',
              style: const TextStyle(
                color: CustomColors.lightGreyText,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.copy,
              size: 20,
              color: CustomColors.greyBackground,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomDetailPageController());

    return WillPopScope(
      onWillPop: () {
        return Future(() => controller.backButton());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: CustomColors.lightGreyBackground,
        appBar: _appBar(),
        body: Stack(
          children: [
            _background(),
            _content(),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _copyCodeButton(),
      ),
    );
  }
}
