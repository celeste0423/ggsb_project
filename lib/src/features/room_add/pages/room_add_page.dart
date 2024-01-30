import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/widgets/full_size_loading_indicator.dart';
import 'package:ggsb_project/src/features/room_add/controllers/room_add_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/text_field_box.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class RoomAddPage extends GetView<RoomAddPageController> {
  const RoomAddPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      leadingWidth: 75,
      title: TitleText(text: '새 공부방'),
      leading: SvgIconButton(
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
        '새로운 방을\n만들어 볼까요?',
        style: TextStyle(
          color: CustomColors.mainBlue,
          fontWeight: FontWeight.w800,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _roomNameTextField() {
    return TextFieldBox(
      textEditingController: controller.roomNameController,
      hintText: '방 이름을 설정해 주세요',
      backgroundColor: CustomColors.lightGreyBackground,
    );
  }

  Widget _cycleSelectButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '어떤 주기로 경쟁할까요?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.roomType('day');
                },
                child: Obx(
                  () => AnimatedContainer(
                    height: 55,
                    decoration: BoxDecoration(
                      color: controller.roomType.value == 'day'
                          ? CustomColors.mainBlack
                          : CustomColors.lightGreyBackground,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    duration: Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        '매일',
                        style: TextStyle(
                          color: controller.roomType.value == 'day'
                              ? Colors.white
                              : CustomColors.lightGreyText,
                          fontSize: 16,
                        ),
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
                  controller.roomType('week');
                },
                child: Obx(
                  () => AnimatedContainer(
                    height: 55,
                    decoration: BoxDecoration(
                      color: controller.roomType.value == 'week'
                          ? CustomColors.mainBlack
                          : CustomColors.lightGreyBackground,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    duration: Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        '매주',
                        style: TextStyle(
                          color: controller.roomType.value == 'week'
                              ? Colors.white
                              : CustomColors.lightGreyText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _cycleSelectButton() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         '어떤 주기로 경쟁할까요?',
  //         style: TextStyle(
  //           fontWeight: FontWeight.w700,
  //           fontSize: 16,
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       PopupMenuButton<String>(
  //         padding: EdgeInsets.zero,
  //         offset: Offset(1, 55),
  //         shape: ShapeBorder.lerp(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           1,
  //         ),
  //         splashRadius: 0,
  //         onSelected: (String roomType) {},
  //         surfaceTintColor: CustomColors.whiteBackground,
  //         itemBuilder: (BuildContext context) {
  //           return [
  //             PopupMenuItem(
  //               value: 'day',
  //               child: Text('매일'),
  //             ),
  //             PopupMenuItem(
  //               value: 'week',
  //               child: Text('매주'),
  //             ),
  //           ];
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.only(left: 30, right: 20),
  //           decoration: BoxDecoration(
  //             color: CustomColors.lightGreyBackground,
  //             borderRadius: const BorderRadius.all(
  //               Radius.circular(20),
  //             ),
  //           ),
  //           height: 55,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 '새로 경쟁할 주기를 선택해 주세요',
  //                 style: TextStyle(
  //                   color: CustomColors.lightGreyText,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               SvgPicture.asset(
  //                 'assets/icons/drop_down.svg',
  //                 width: 12,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _inviteCodeButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '함께 경쟁할 친구를 초대해 보세요',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.inviteCodeCopyButton();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 20),
            decoration: BoxDecoration(
              color: CustomColors.lightGreyBackground,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    controller.roomId.value,
                    style: TextStyle(
                      color: CustomColors.lightGreyText,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.copy,
                  size: 20,
                  color: CustomColors.greyBackground,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '원하시는 대표 색상을 골라 주세요',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: const BoxDecoration(
            color: CustomColors.lightGreyBackground,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          height: 125,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: GetBuilder<RoomAddPageController>(
              builder: (RoomAddPageController controller) {
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(12, (index) {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.selectedColor(controller.colors[index]);
                        controller.update();
                      },
                      child: _colorIcon(
                        controller.colors[index],
                        controller.colors[index] ==
                            controller.selectedColor.value,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorIcon(Color color, bool isSelected) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(45),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            )
          : Container(),
    );
  }

  Widget _addButton() {
    return MainButton(
      buttonText: '방 완성',
      width: Get.width - 40,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      onTap: () {
        controller.addRoomButton();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RoomAddPageController());
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
                  _roomNameTextField(),
                  SizedBox(height: 30),
                  _cycleSelectButton(),
                  SizedBox(height: 30),
                  _inviteCodeButton(),
                  SizedBox(height: 30),
                  _colorSelector(),
                  SizedBox(height: 90),
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
