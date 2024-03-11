import 'package:circular_motion/circular_motion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:rive/rive.dart';

// @override
// void initState() {
//   super.initState();
//   setState(() {
//     isLoading = true;
//   });
//
//   setState(() {
//     isLoading = false;
//   });
//   // print('로딩');
// }
//
// @override
// void didUpdateWidget(CharacterList oldWidget) {
//   super.didUpdateWidget(oldWidget);
//   if (oldWidget.roomStreamList != widget.roomStreamList) {
//     for (int index = 0; index < widget.roomStreamList.length; index++) {
//       riveCharacterInit(index);
//     }
//   }
// }

Widget characterList(
  bool isLoading,
  List<RoomStreamModel> roomStreamList,
  List<Artboard?> artboardList,
) {
  return !isLoading
      ? Stack(
          children: [
            PieChart(
              PieChartData(
                centerSpaceRadius: (Get.width - 100) / 2 - 40,
                borderData: FlBorderData(show: false),
                sections: _chartData(roomStreamList),
              ),
            ),
            CircularMotion.builder(
              itemCount: roomStreamList.length,
              builder: (context, index) {
                return _characterCard(
                  index,
                  roomStreamList.length,
                  artboardList[index]!,
                );
              },
            ),
          ],
        )
      : const FullSizeLoadingIndicator(
          backgroundColor: Colors.transparent,
        );
}

Widget _characterCard(
  int index,
  int length,
  Artboard artboard,
) {
  return SizedBox(
    width: 210 - length * 20,
    height: 210 - length * 20,
    child: Rive(
      artboard: artboard.instance(),
    ),
  );
}

void onRiveInit(
  Artboard artboard,
  int index,
  List<List<SMINumber?>> stateMachineList,
  List<StateMachineController?> riveControllers,
  List<RoomStreamModel> roomStreamList,
) {
  riveControllers[index] =
      StateMachineController.fromArtboard(artboard, 'character');
  artboard.addController(riveControllers[index]!);
  for (int stateMachineIndex = 0; stateMachineIndex < 4; stateMachineIndex++) {
    stateMachineList[index][stateMachineIndex] = riveControllers[index]!
            .findInput<double>(_getInputNameByIndex(stateMachineIndex))
        as SMINumber;
  }
  riveCharacterInit(index, stateMachineList, roomStreamList);
}

String _getInputNameByIndex(int index) {
  switch (index) {
    case 0:
      return 'action';
    case 1:
      return 'hat';
    case 2:
      return 'shield';
    case 3:
      return 'color';
    default:
      throw Exception('Invalid index: $index');
  }
}

void riveCharacterInit(
    int controllerIndex,
    List<List<SMINumber?>> stateMachineList,
    List<RoomStreamModel> roomStreamList) {
  if (stateMachineList[0][0] != null) {
    CharacterModel characterModel =
        roomStreamList[controllerIndex].characterData!;
    stateMachineList[controllerIndex][0]!.value =
        characterModel.actionState!.toDouble();
    stateMachineList[controllerIndex][1]!.value =
        characterModel.hat!.toDouble();
    stateMachineList[controllerIndex][2]!.value =
        characterModel.shield!.toDouble();
    stateMachineList[controllerIndex][3]!.value =
        characterModel.bodyColor!.toDouble();
  }
}

List<PieChartSectionData> _chartData(List<RoomStreamModel> roomStreamList) {
  return List.generate(
    roomStreamList.length,
    (index) {
      return PieChartSectionData(
        radius: 35,
        color: CustomColors.bodyColorToRoomColor(
          roomStreamList[index].characterData!.bodyColor!,
        ),
        title: roomStreamList[index].nickname,
        value: roomStreamList[index].totalLiveSeconds!.toDouble(),
        titleStyle: const TextStyle(
          color: CustomColors.whiteText,
        ),
      );
    },
  );
}
