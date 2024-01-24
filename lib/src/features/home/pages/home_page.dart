import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/home/controllers/home_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TitleText(text: '홈'),
      ),
    );
  }

  Widget _charactorBox() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: CustomColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(150),
      ),
    );
  }

  Widget _buttonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MainButton(
              buttonText: '시간 측정',
              onTap: () {},
              icon: SvgPicture.asset(
                'assets/icons/play.svg',
                width: 20,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: MainButton(
              buttonText: '방 추가',
              textStyle: TextStyle(
                color: CustomColors.lightGreyText,
              ),
              backgroundColor: CustomColors.lightGreyBackground,
              onTap: () {},
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTab() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _charactorBox(),
            _buttonsRow(),
            _bottomTab(),
          ],
        ),
      ),
    );
  }
}
