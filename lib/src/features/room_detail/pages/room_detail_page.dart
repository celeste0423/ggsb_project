import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/features/room_detail/controllers/room_detail_page_controller.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/calcTotalLiveSeconds.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomDetailPage extends GetView<RoomDetailPageController> {
  const RoomDetailPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      leading: Align(
        alignment: Alignment.centerRight,
        child: SvgIconButton(
          assetPath: 'assets/icons/back.svg',
          iconColor: Colors.white,
          onTap: () {
            Get.back();
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
                child: Text(
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
                  controller.getOutButton();
                },
                child: Text(
                  '방 나가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        SizedBox(width: 30),
      ],
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: 105),
          StreamBuilder(
            stream: controller.roomUserListStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: CustomColors.mainBlue,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('불러오는 중 에러가 발생했습니다.');
              } else {
                List<RoomStreamModel> roomStreamList = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.width - 60,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      GetBuilder<RoomDetailPageController>(
                        id: 'roomUserListTimer',
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
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _rankingCard(int index, RoomStreamModel roomStreamModel) {
    RoomStreamModel liveRoomStreamModel =
        CalcTotalLiveSeconds.calcTotalLiveSecInRoomStream(roomStreamModel);
    return Stack(
      children: [
        Container(
          height: 110,
          padding: EdgeInsets.symmetric(horizontal: 30),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
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
                    roomStreamModel.nickname!,
                    style: TextStyle(
                      color: CustomColors.mainBlue,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    SecondsUtil.convertToDigitString(
                      liveRoomStreamModel.totalLiveSeconds!,
                    ),
                    style: TextStyle(
                      color: CustomColors.blackText,
                      fontWeight: FontWeight.w600,
                      fontSize: index == 0 ? 20 : 16,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      color: CustomColors.lightGreyBackground,
                      strokeWidth: 8,
                      value: 1,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 8,
                      value: 0.5,
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 25,
                    child: Text(
                      '60%',
                      style: TextStyle(
                        color: CustomColors.lightGreyText,
                        fontSize: 12,
                      ),
                    ),
                  )
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
                roomStreamModel.uid != AuthController.to.user.value.uid,
            child: SvgIconButton(
              assetPath: 'assets/icons/cancel.svg',
              onTap: () {
                controller.deleteUserButton(roomStreamModel);
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
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          height: controller.backgroundAnimation.value ? 275 : 0,
          width: Get.width,
          decoration: BoxDecoration(
            color: CustomColors.nameToRoomColor(controller.roomModel.color!),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
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
              offset: Offset(0, 4),
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
              style: TextStyle(
                color: CustomColors.lightGreyText,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            Icon(
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
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      floatingActionButton: _floatingActionButton(),
    );
  }
}
