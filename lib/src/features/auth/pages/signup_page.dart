import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/signup_page_controller.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/input_textfield.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';

class SignupPage extends GetView<SignupPageController> {
  final String uid;
  final String email;

  const SignupPage({
    Key? key,
    required this.uid,
    required this.email,
  }) : super(key: key);

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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: Get.height - 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: CustomColors.lightGreyBackground,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                BackgroundTextField(
                  textEditingController: controller.nicknameController,
                  backgroundColor: CustomColors.lightGreyBackground,
                  hintText: '닉네임(2~5자)',
                  maxLength: 5,
                ),
                BackgroundTextField(
                  textEditingController: controller.schoolController,
                  backgroundColor: CustomColors.lightGreyBackground,
                  hintText: '학교',
                ),
                Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.isMale(true);
                          },
                          child: AnimatedContainer(
                            height: 55,
                            decoration: BoxDecoration(
                              color: controller.isMale.value
                                  ? CustomColors.mainBlack
                                  : CustomColors.lightGreyBackground,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            duration: Duration(milliseconds: 300),
                            child: Center(
                              child: Text(
                                '남',
                                style: TextStyle(
                                  color: controller.isMale.value
                                      ? Colors.white
                                      : CustomColors.lightGreyText,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.isMale(false);
                          },
                          child: AnimatedContainer(
                            height: 55,
                            decoration: BoxDecoration(
                              color: controller.isMale.value
                                  ? CustomColors.lightGreyBackground
                                  : CustomColors.mainBlack,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            duration: Duration(milliseconds: 300),
                            child: Center(
                              child: Text(
                                '여',
                                style: TextStyle(
                                  color: controller.isMale.value
                                      ? CustomColors.lightGreyText
                                      : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                MainButton(
                  buttonText: '승부 시작 !',
                  onTap: () {
                    controller.signUpButton();
                  },
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Get.put(SignupPageController());
    controller.uid(uid);
    controller.email(email);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.mainBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoCaption(),
                SizedBox(height: 45),
                _announcementText(),
                SizedBox(height: 30),
                _inputTab(),
              ],
            ),
            Obx(() => controller.isSignupLoading.value
                ? FullSizeLoadingIndicator(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }
}
