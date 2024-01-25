import 'package:flutter/material.dart';
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
    return controller.isRoomList.value
        ? FutureBuilder<List<RoomModel>>(
            future: controller.getRoomList(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<RoomModel>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: CustomColors.mainBlue);
              } else if (snapshot.hasError) {
                return Text('에러 발생');
              } else {
                List<RoomModel> roomList = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: roomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _roomCard(roomList[index]);
                  },
                );
              }
            },
          )
        : Container();
  }

  Widget _roomCard(RoomModel roomModel) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.nameToRoomColor(roomModel.color!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(),
          Text(
            roomModel.roomName!,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Text(
                roomModel.roomName!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                roomModel.roomName!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomListPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _sayingBox(),
              _roomList(),
            ],
          ),
        ),
      ),
    );
  }
}
