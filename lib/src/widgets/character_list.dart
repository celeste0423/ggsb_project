import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:rive/rive.dart';

class CharacterList extends StatefulWidget {
  final List<RoomStreamModel> roomStreamList;

  CharacterList({
    Key? key,
    required this.roomStreamList,
  }) : super(key: key);

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late List<List<SMINumber?>> stateMachineList;
  late List<StateMachineController?> riveControllers;

  @override
  void initState() {
    super.initState();
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
  }

  Widget _characterCard(int index) {
    int length = widget.roomStreamList.length;
    return SizedBox(
      width: 110 + length * 20,
      height: 110 + length * 20,
      child: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/riv/character.riv',
              stateMachines: ["character"],
              onInit: (artboard) => onRiveInit(artboard, index),
            ),
          ),
          Text(
            widget.roomStreamList[index]!.nickname!,
            style: TextStyle(
              color: CustomColors.blackText,
            ),
          )
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

  @override
  Widget build(BuildContext context) {
    for (int index = 0; index < widget.roomStreamList.length; index++) {
      riveCharacterInit(index);
    }
    return CircularMotion.builder(
      itemCount: widget.roomStreamList.length,
      builder: (context, index) {
        return _characterCard(index);
      },
    );
  }
}
