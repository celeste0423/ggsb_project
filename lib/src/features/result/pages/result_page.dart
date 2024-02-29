import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/result/controllers/result_page_controller.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

class ResultPage extends GetView<ResultPageController> {
  const ResultPage({super.key});

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              child: SvgPicture.asset('assets/images/caption_logo.svg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: TabBarView(
        controller: controller.roomTabController,
        children: _resultBoxList(),
      ),
    );
  }

  List<Widget> _resultBoxList() {
    return controller.roomModelList.map((RoomModel roomModel) {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: CustomColors.whiteBackground,
        ),
        child: Column(
          children: [
            Text(
              '${DateFormat('yyyy - MM - dd').format(DateTime.now())}',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 15),
            // RiveAnimation.asset(
            //   'assets/riv/character.riv',
            //   stateMachines: ["character"],
            // ),
            Image.asset('assets/icons/trophy.png', width: 20),
            Text(
              '12:36:52',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            Text(
              '민재',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '01:52:30',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              '엽엽',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              '00:12:30',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
      ;
    }).toList();
  }

  Widget _shareButton() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainButton(
              onTap: () {},
              icon: Image.asset('assets/icons/insta_share.png'),
              buttonText: '공유',
              backgroundColor: CustomColors.blackRoom,
              height: 63,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainButton(
              onTap: () {},
              icon: Image.asset('assets/icons/download.png'),
              buttonText: '이미지 저장',
              backgroundColor: CustomColors.whiteBackground,
              height: 63,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResultPageController());
    return !controller.isPageLoading.value
        ? Scaffold(
            backgroundColor: CustomColors.mainBlue,
            body: Center(
                child: Column(
              children: [
                _title(),
                _resultBox(),
              ],
            )),
          )
        : FullSizeLoadingIndicator(
            backgroundColor: CustomColors.mainBlue.withOpacity(0.5),
          );
  }
}
