import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/data_analyze/controller/data_analyze_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:table_calendar/table_calendar.dart';

class DataAnalyzePage extends GetView<DataAnalyzePageController> {
  const DataAnalyzePage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      leading: SvgIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: Get.back,
      ),
      title: TitleText(
        text: '기록 분석',
      ),
    );
  }

  Widget _calendar() {
    return Obx(
      () => TableCalendar(
        focusedDay: controller.focusedDay.value,
        firstDay: DateTime(2024, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        locale: 'ko-KR',
        daysOfWeekHeight: 30,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        onDaySelected: (selectedDateTime, focusedDay) {
          if (!isSameDay(selectedDateTime, controller.selectedDay.value)) {
            controller.onDaySelected(selectedDateTime);
            controller.focusedDay(focusedDay);
          }
        },
        eventLoader: (day) {
          if (day.day % 2 == 0) {
            return ['hi'];
          }
          return [];
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(
            color: CustomColors.greyText,
          ),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
          outsideDaysVisible: false,
          todayTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CustomColors.blackText,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: CustomColors.mainBlue,
              width: 1,
            ),
          ),
          selectedDecoration: const BoxDecoration(
            color: CustomColors.mainBlue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DataAnalyzePageController());
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: _calendar(), // Calendar 위젯을 출력합니다.
      ),
    );
  }
}
