import 'package:flutter/material.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:rive/rive.dart';
import "package:rxdart/rxdart.dart";

class Character extends StatefulWidget {
  final String roomId;
  final String roomStreamId;
  final int length;
  final int index;

  const Character({
    Key? key,
    required this.roomStreamId,
    required this.roomId,
    required this.length,
    required this.index,
  }) : super(key: key);

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  late List<SMINumber?> stateMachineList;
  late StateMachineController? riveController;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stateMachineList =
        List<SMINumber?>.generate(4, (stateMachineIndex) => null);
  }

  // @override
  // void didUpdateWidget(Character oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.roomStreamList != widget.roomStreamList) {
  //     for (int index = 0; index < widget.roomStreamList.length; index++) {
  //       riveCharacterInit(index);
  //     }
  //   }
  // }

  Widget _characterCard(int length, String roomId, String uid) {
    print('카드 빌드');
    return SizedBox(
      width: 210 - length * 18,
      height: 210 - length * 18,
      child: StreamBuilder(
        stream: RoomStreamRepository()
            .getRoomStreamAsStream(roomId, uid)
            .debounceTime(Duration(milliseconds: widget.index * 500)),
        builder: (context, snapshot) {
          print('바뀜 ${uid} ${roomId}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('불러오는 중 에러가 발생했습니다.');
          } else {
            riveCharacterInit(snapshot.data!);
            return RiveAnimation.asset(
              'assets/riv/character.riv',
              stateMachines: ["character"],
              onInit: (artboard) => onRiveInit(artboard, snapshot.data!),
            );
          }
        },
      ),
    );
  }

  void onRiveInit(Artboard artboard, RoomStreamModel roomStreamModel) {
    riveController = StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    for (int stateMachineIndex = 0;
        stateMachineIndex < 4;
        stateMachineIndex++) {
      stateMachineList[stateMachineIndex] = riveController!
              .findInput<double>(_getInputNameByIndex(stateMachineIndex))
          as SMINumber;
    }
    riveCharacterInit(roomStreamModel);
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

  void riveCharacterInit(RoomStreamModel roomStreamModel) {
    if (stateMachineList[0] != null) {
      CharacterModel characterModel = roomStreamModel.characterData!;
      stateMachineList[0]!.value = characterModel.actionState!.toDouble();
      stateMachineList[1]!.value = characterModel.hat!.toDouble();
      stateMachineList[2]!.value = characterModel.shield!.toDouble();
      stateMachineList[3]!.value = characterModel.bodyColor!.toDouble();
    }
  }

  // PieChartSectionData chartData() {
  //   return PieChartSectionData(
  //     radius: 35,
  //     color: CustomColors.bodyColorToRoomColor(
  //       widget.roomStreamList[index].characterData!.bodyColor!,
  //     ),
  //     // borderSide: BorderSide(
  //     //   color: Colors.white,
  //     //   width: 3,
  //     // ),
  //     title: widget.roomStreamList[index].nickname,
  //     value: widget.roomStreamList[index].totalLiveSeconds!.toDouble(),
  //     titleStyle: const TextStyle(
  //       color: CustomColors.whiteText,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return _characterCard(widget.length, widget.roomId, widget.roomStreamId);
  }
}
