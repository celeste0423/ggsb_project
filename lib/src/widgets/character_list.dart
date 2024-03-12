import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:rive/rive.dart';

class CharacterList extends StatefulWidget {
  final List<RoomStreamModel> roomStreamList;

  const CharacterList({
    Key? key,
    required this.roomStreamList,
  }) : super(key: key);

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late List<List<SMINumber?>> stateMachineList;
  late List<StateMachineController?> riveControllers;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   isLoading = true;
    // });
    stateMachineList = List<List<SMINumber?>>.generate(
      widget.roomStreamList.length,
      (roomStreamIndex) => List<SMINumber?>.generate(
        4,
        (stateMachineIndex) => null,
      ),
    );
    riveControllers = List.generate(
      widget.roomStreamList.length,
      (index) => null,
    );
    // setState(() {
    //   isLoading = false;
    // });
    // print('로딩');
  }

  @override
  void didUpdateWidget(CharacterList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomStreamList != widget.roomStreamList) {
      for (int index = 0; index < widget.roomStreamList.length; index++) {
        riveCharacterInit(index);
      }
    }
  }

  Widget _characterCard(int index) {
    int length = widget.roomStreamList.length;
    return SizedBox(
      width: 210 - length * 20,
      height: 210 - length * 20,
      child: Stack(
        children: [
          RiveAnimation.asset(
            'assets/riv/character.riv',
            stateMachines: ["character"],
            onInit: (artboard) => onRiveInit(artboard, index),
          ),
        ],
      ),
    );
  }

  void onRiveInit(Artboard artboard, int index) {
    riveControllers[index] =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveControllers[index]!);
    for (int stateMachineIndex = 0;
        stateMachineIndex < 4;
        stateMachineIndex++) {
      stateMachineList[index][stateMachineIndex] = riveControllers[index]!
              .findInput<double>(_getInputNameByIndex(stateMachineIndex))
          as SMINumber;
    }
    riveCharacterInit(index);
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

  void riveCharacterInit(int controllerIndex) {
    if (stateMachineList[controllerIndex][0] != null) {
      CharacterModel characterModel =
          widget.roomStreamList[controllerIndex].characterData!;
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

  List<PieChartSectionData> _chartData() {
    return List.generate(
      widget.roomStreamList.length,
      (index) {
        return PieChartSectionData(
          radius: 35,
          color: CustomColors.bodyColorToRoomColor(
            widget.roomStreamList[index].characterData!.bodyColor!,
          ),
          // borderSide: BorderSide(
          //   color: Colors.white,
          //   width: 3,
          // ),
          title: widget.roomStreamList[index].nickname,
          value: widget.roomStreamList[index].totalLiveSeconds!.toDouble(),
          titleStyle: const TextStyle(
            color: CustomColors.whiteText,
          ),
          // badgeWidget: _characterCard(index),
          badgeWidget: _characterCard(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: (Get.width - 100) / 2 - 80,
        borderData: FlBorderData(show: false),
        sections: _chartData(),
      ),
    );
  }
}
