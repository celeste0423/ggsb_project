import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/signup_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class SignupPage extends GetView<SignupPageController> {
  const SignupPage({super.key});

  Widget _logoCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SvgPicture.asset('assets/images/caption_logo.svg'),
    );
  }

  Widget _announcementText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '당신에 대해 알려주세요!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '해당 정보로 다양한 랭킹 배틀에 참여할 수 있습니다.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTab() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SignupPageController());
    return Scaffold(
        backgroundColor: CustomColors.mainBlue,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _logoCaption(),
              SizedBox(height: 50),
              _announcementText(),
              SizedBox(height: 50),
              _inputTab(),
            ],
          ),
        ));
  }
}
