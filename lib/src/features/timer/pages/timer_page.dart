import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/features/timer/controllers/timer_page_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';

class TimerPage extends GetView<TimerPageController> {
  const TimerPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leadingWidth: 75,
      title: Text(
        controller.today.value,
        style: TextStyle(
          color: CustomColors.lightGreyText,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: SvgIconButton(
        assetName: 'assets/icons/back.svg',
        onTap: () {
          Get.back();
        },
      ),
    );
  }

  Widget _content() {
    return Container(
      width: Get.width,
      height: Get.height - 75,
      child: Column(
        children: [
          _map(),
          _time(),
          _playButton(),
          SizedBox(height: 20),
          _roomTabView(),
        ],
      ),
    );
  }

  Widget _map() {
    return Container(
      margin: EdgeInsets.all(30),
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
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Text(
        '00:01:52',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _playButton() {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.only(left: 19, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: CustomColors.mainBlue,
      ),
      child: SvgPicture.asset(
        'assets/icons/play.svg',
      ),
    );
  }

  Widget _roomTabView() {
    return Expanded(
      child: Obx(() {
        return controller.noRooms.value
            ? Center(
                child: Text(
                  '나만의 버꿍리스트를 만들어보세요',
                  style: TextStyle(color: CustomColors.blackText),
                ),
              )
            : controller.isPageLoading.value
                ? Center(
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
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.mainBlue,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('불러오는 중 에러가 발생했습니다.');
          } else {
            List<RoomStreamModel> roomStreamList = snapshot.data!;
            return Column(
              children: [
                Text(
                  roomModel.roomName!,
                  style: TextStyle(
                    color: CustomColors.lightGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: roomStreamList.length,
                  itemBuilder: (context, index) {
                    return _rankingCard(
                      index,
                      roomStreamList[index],
                    );
                  },
                )
              ],
            );
          }
        },
      );
    }).toList();
  }

  Widget _rankingCard(int index, RoomStreamModel roomStreamModel) {
    RoomStreamModel liveRoomStreamModel =
        controller.calcTotalLiveSec(roomStreamModel);
    //시간 계산
    int hour = (liveRoomStreamModel.totalLiveSeconds! / 3600).toInt();
    int minute = ((liveRoomStreamModel.totalLiveSeconds! % 3600) / 60).toInt();
    int second = (liveRoomStreamModel.totalLiveSeconds! % 60).toInt();
    String liveTotalTimer = '${hour}:${minute}:${second}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${index + 1}등',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            roomStreamModel.nickname!,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        Text(
          liveTotalTimer,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _background() {
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: Get.height - 415,
        width: Get.width,
        decoration: BoxDecoration(
          color: CustomColors.mainBlack,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TimerPageController());
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: _appBar(),
            body: Stack(
              children: [
                _background(),
                _content(),
              ],
            )),
        Obx(
          () => controller.isPageLoading.value
              ? FullSizeLoadingIndicator(
                  backgroundColor: Colors.black.withOpacity(0.5),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
