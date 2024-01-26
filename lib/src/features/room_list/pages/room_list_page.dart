import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/room_list/controllers/room_list_page_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomListPage extends GetView<RoomListPageController> {
  const RoomListPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leadingWidth: 75,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TitleText(text: '방 목록'),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Image.asset(
            'assets/icons/setting.png',
            width: 30,
          ),
        ),
      ],
    );
  }

  Widget _sayingBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _roomList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Obx(
        () => controller.isRoomList.value
            ? FutureBuilder<List<RoomModel>>(
                future: controller.getRoomList(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<RoomModel>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.mainBlue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('에러 발생');
                  } else {
                    List<RoomModel> roomList = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: roomList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < roomList.length) {
                          return _roomCard(roomList[index]);
                        } else {
                          return _addRoomCard();
                        }
                      },
                    );
                  }
                },
              )
            : Container(
                height: 20,
                width: 50,
                color: Colors.red,
              ),
      ),
    );
  }

  Widget _roomCard(RoomModel roomModel) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.nameToRoomColor(roomModel.color!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 16),
              Text(
                roomModel.roomName!,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${roomModel.uidList!.length}/6명',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    roomModel.creatorName!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addRoomCard() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/add.svg',
            width: 25,
            color: CustomColors.greyBackground,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomListPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _sayingBox(),
            Expanded(child: _roomList()),
          ],
        ),
      ),
    );
  }
}
