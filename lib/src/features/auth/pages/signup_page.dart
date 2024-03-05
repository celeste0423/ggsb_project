import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/signup_page_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/text_field_box.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends GetView<SignupPageController> {
  final String uid;
  final String email;

  const SignupPage({
    Key? key,
    required this.uid,
    required this.email,
  }) : super(key: key);

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: controller.isProfileEditing == null ? 140 : 75,
      leading: controller.isProfileEditing == null
          ? _logoCaption()
          : ImageIconButton(
              assetPath: 'assets/icons/back.svg',
              iconColor: Colors.white,
              onTap: Get.back,
            ),
    );
  }

  Widget _logoCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SvgPicture.asset(
        'assets/images/caption_logo.svg',
      ),
    );
  }

  Widget _announcementText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.isProfileEditing == null ? '당신에 대해 알려주세요!' : '프로필 수정',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
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
          horizontal: 25,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height - 250 < 620 ? 620 : Get.height - 270,
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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 280,
                        height: 280,
                        padding: const EdgeInsets.only(left: 0, bottom: 10),
                        child: RiveAnimation.asset(
                          'assets/riv/character.riv',
                          stateMachines: ["character"],
                          onInit: controller.onRiveInit,
                        ),
                      ),
                    ),
                  ),
                ),
                TextFieldBox(
                  textEditingController: controller.nicknameController,
                  backgroundColor: CustomColors.lightGreyBackground,
                  hintText: '닉네임(2~8자)',
                  maxLength: 8,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(Get.context!).unfocus(),
                  autoFocus: controller.isProfileEditing == null ? true : false,
                ),
                _schoolSelectButton(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
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
                    controller.isProfileEditing == null
                        ? _termsAgreement()
                        : const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: controller.isProfileEditing == null
                          ? MainButton(
                              buttonText: '승부 시작 !',
                              onTap: () {
                                controller.signUpButton();
                              },
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : MainButton(
                              buttonText: '수정 완료',
                              onTap: () {
                                controller.profileEditButton();
                              },
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ],
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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '학교 이름을 검색해주세요',
                    style: TextStyle(
                      fontSize: 25,
                      color: CustomColors.blackText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _schoolTypeSelector('elem_list', '초등학교'),
                      _schoolTypeSelector('midd_list', '중학교'),
                      _schoolTypeSelector('high_list', '고등학교'),
                      _schoolTypeSelector('univ_list', '대학교'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.schoolSearchController,
                        cursorColor: Colors.black.withOpacity(0.5),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CustomColors.blackText,
                        ),
                        decoration: const InputDecoration(
                          hintText: '검색어를 입력하세요',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: CustomColors.lightGreyText,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.mainBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        onSubmitted: (_) {
                          controller.schoolSearchButton();
                        },
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        controller.schoolSearchButton();
                      },
                      child: const Icon(
                        Icons.search,
                        color: CustomColors.blackText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    if (controller.isSchoolLoading.value) {
                      return Center(child: loadingIndicator());
                    } else if (controller.schoolNameList.isEmpty) {
                      return const Center(child: Text('검색 결과가 없습니다'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.schoolNameList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return controller.schoolNameList[index] ==
                                  controller.nullSchoolName
                              ? SizedBox(
                                  height: Get.height - 250,
                                  child: const Center(
                                    child: Text('학교를 선택하세요'),
                                  ),
                                )
                              : CupertinoButton(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  onPressed: () {
                                    controller.schoolName(
                                        controller.schoolNameList[index]);
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
            Positioned(
              right: 0,
              top: 0,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                  color: CustomColors.greyBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _schoolTypeSelector(String value, String text) {
    return GetBuilder<SignupPageController>(
      id: 'schoolType',
      builder: (_) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        onPressed: () {
          controller.selectedSchoolType = value;
          controller.update(['schoolType']);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: controller.selectedSchoolType == value
                  ? CustomColors.mainBlue
                  : CustomColors.greyBackground,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            text,
            style: TextStyle(
              color: controller.selectedSchoolType == value
                  ? CustomColors.mainBlue
                  : CustomColors.greyBackground,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _termsAgreement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: CustomColors.greyText,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: '이용약관 ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Uri uri =
                              Uri.parse(ServiceUrls.serviceTermsNotionUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            openAlertDialog(title: '오류 발생');
                          }
                        },
                    ),
                    const TextSpan(text: '및 '),
                    TextSpan(
                      text: '개인정보처리방침',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Uri uri = Uri.parse(
                              ServiceUrls.personalInformationPolicyNotionUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            openAlertDialog(title: '오류 발생');
                          }
                        },
                    ),
                    const TextSpan(text: ' 동의'),
                  ],
                ),
              ),
              Obx(
                () => Checkbox(
                  value: controller.isTermAgreed.value,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool? newValue) {
                    controller.isTermAgreed(newValue);
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: CustomColors.greyText,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(text: '마케팅 정보 수신 동의 (선택)'),
                  ],
                ),
              ),
              Obx(
                () => Checkbox(
                  value: controller.isMarketingAgreed.value,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool? newValue) {
                    controller.isMarketingAgreed(newValue);
                  },
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
    print('높이 ${Get.height}');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Get.put(SignupPageController());
    controller.uid(uid);
    controller.email(email);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.mainBlue,
      appBar: _appBar(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(Get.context!).padding.top),
              _announcementText(),
              const SizedBox(height: 30),
              _inputTab(),
            ],
          ),
          Obx(
            () => Visibility(
              visible: controller.isSignupLoading.value,
              child: FullSizeLoadingIndicator(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
