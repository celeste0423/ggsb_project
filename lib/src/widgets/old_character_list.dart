import 'package:circular_motion/circular_motion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/full_size_loading_indicator.dart';
import 'package:rive/rive.dart';

class OldCharacterList extends StatefulWidget {
  final List<RoomStreamModel> roomStreamList;

  const OldCharacterList({
    Key? key,
    required this.roomStreamList,
  }) : super(key: key);

  @override
  State<OldCharacterList> createState() => _OldCharacterListState();
}

class _OldCharacterListState extends State<OldCharacterList> {
  late List<List<SMINumber?>> stateMachineList;
  late List<StateMachineController?> riveControllers;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
    // print('로딩');
  }

  @override
  void didUpdateWidget(OldCharacterList oldWidget) {
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
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: SizedBox(
          //     width: 110 + length * 20,
          //     child: Center(
          //       child: Container(
          //         height: 25,
          //         padding: const EdgeInsets.symmetric(horizontal: 15),
          //         decoration: BoxDecoration(
          //           color: CustomColors.bodyColorToRoomColor(
          //             widget.roomStreamList[index].characterData!.bodyColor!,
          //           ),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Text(
          //           widget.roomStreamList[index].nickname!,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //             color: CustomColors.whiteText,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
    if (stateMachineList[0][0] != null) {
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Stack(
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: (Get.width - 100) / 2 - 40,
                  borderData: FlBorderData(show: false),
                  sections: _chartData(),
                ),
              ),
              CircularMotion.builder(
                itemCount: widget.roomStreamList.length,
                builder: (context, index) {
                  return _characterCard(index);
                },
              ),
            ],
          )
        : const FullSizeLoadingIndicator(
            backgroundColor: Colors.transparent,
          );
  }
}
