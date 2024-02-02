import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/signup_page_controller.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/text_field_box.dart';

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
          child: SizedBox(
            height: Get.height - 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: CustomColors.lightGreyBackground,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                TextFieldBox(
                  textEditingController: controller.nicknameController,
                  backgroundColor: CustomColors.lightGreyBackground,
                  hintText: '닉네임(2~5자)',
                  maxLength: 5,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(Get.context!).unfocus(),
                  autoFocus: true,
                ),
                _schoolSelectButton(),
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
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            duration: const Duration(milliseconds: 300),
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
                      const SizedBox(width: 20),
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
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            duration: const Duration(milliseconds: 300),
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
                  textStyle: const TextStyle(
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

  Widget _schoolSelectButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.dialog(_schoolSelectDialog());
      },
      child: Container(
        padding: const EdgeInsets.only(left: 30),
        height: 55,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: CustomColors.lightGreyBackground,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    controller.schoolName.value,
                    style: TextStyle(
                        color: controller.schoolName.value ==
                                controller.nullSchoolName
                            ? CustomColors.lightGreyText
                            : CustomColors.blackText),
                  ),
                ),
              ),
              Visibility(
                visible:
                    controller.schoolName.value != controller.nullSchoolName,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  onPressed: () {
                    controller.schoolName(controller.nullSchoolName);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                    color: CustomColors.greyBackground,
                    width: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _schoolSelectDialog() {
    return Dialog(
      backgroundColor: CustomColors.lightGreyBackground,
      insetPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFieldBox(
                    textEditingController: controller.schoolSearchController,
                    backgroundColor: CustomColors.lightGreyBackground,
                    hintText: '학교를 검색하세요',
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      controller.schoolSearchButton();
                    },
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () {
                    controller.schoolSearchButton();
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: CustomColors.mainBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _schoolTypeSelector('elem_list', '초등학교'),
                  _schoolTypeSelector('midd_list', '중학교'),
                  _schoolTypeSelector('high_list', '고등학교'),
                  _schoolTypeSelector('univ_list', '대학교'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isSchoolEntered.isFalse && !controller.isSchoolLoading.value) {
                  return Center(child: Text('학교를 검색하세요'));
                }
                // else if (controller.isSchoolLoading.value) {
                //   return Center(child: CircularProgressIndicator());
                // }
                else if (!controller.isSchoolEntered.isTrue && !controller.isSchoolLoading.value) {
                  // 검색 결과가 없는 경우
                  return Center(child: Text('검색 결과가 없습니다'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.schoolNameList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        onPressed: () {
                          controller.schoolName(controller.schoolNameList[index]);
                          Get.back();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.schoolNameList[index],
                              style: const TextStyle(
                                color: CustomColors.mainBlack,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }




  Widget _schoolTypeSelector(String value, String text) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<SignupPageController>(
            builder: (_) => Radio(
              value: value,
              groupValue: controller.selectedSchoolType,
              onChanged: (value) {
                controller.selectedSchoolType = value as String;
                controller.update();
              },
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.blackText,
              fontSize: 12,
            ),
          ),
        ],
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
                const SizedBox(height: 45),
                _announcementText(),
                const SizedBox(height: 30),
                _inputTab(),
              ],
            ),
            Obx(() => controller.isSignupLoading.value
                ? FullSizeLoadingIndicator(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
