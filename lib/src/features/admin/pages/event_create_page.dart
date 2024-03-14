import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/admin/controllers/event_create_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/text_field_box.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class EventCreatePage extends GetView<EventCreatePageController> {
  const EventCreatePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leadingWidth: 75,
      title: TitleText(text: '새 이벤트'),
      leading: ImageIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: () {
          Get.back();
        },
      ),
    );
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '새로운 이벤트\n공검팀 화이팅',
        style: TextStyle(
          color: CustomColors.mainBlue,
          fontWeight: FontWeight.w800,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return TextFieldBox(
      textEditingController: controller.titleController,
      hintText: '제목을 설정해주세요(중복 금지)',
      backgroundColor: CustomColors.lightGreyBackground,
    );
  }

  Widget _contentTextField() {
    return TextFieldBox(
      textEditingController: controller.contentController,
      hintText: '내용을 설정해주세요',
      backgroundColor: CustomColors.lightGreyBackground,
    );
  }

  Widget _imgUrlTextField() {
    return TextFieldBox(
      textEditingController: controller.imgUrlController,
      hintText: 'imgUrl을 넣어주세요',
      backgroundColor: CustomColors.lightGreyBackground,
    );
  }

  Widget _contentUrlTextField() {
    return TextFieldBox(
      textEditingController: controller.contentUrlController,
      hintText: 'content Url을 넣어주세요',
      backgroundColor: CustomColors.lightGreyBackground,
    );
  }

  Widget _addButton() {
    return MainButton(
      buttonText: '이벤트 업로드',
      width: Get.width - 40,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      onTap: () {
        controller.addEventButton();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EventCreatePageController());
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _title(),
                  _titleTextField(),
                  const SizedBox(height: 30),
                  _contentTextField(),
                  const SizedBox(height: 30),
                  _imgUrlTextField(),
                  const SizedBox(height: 30),
                  _contentUrlTextField(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _addButton(),
        ),
        Obx(
          () => Visibility(
            visible: controller.isPageLoading.value,
            child: FullSizeLoadingIndicator(
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
