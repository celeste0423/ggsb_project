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
  final RiveFile riveFile;

  const Character({
    Key? key,
    required this.roomStreamId,
    required this.roomId,
    required this.length,
    required this.index,
    required this.riveFile,
  }) : super(key: key);

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  bool isFirstLoad = true;

  SMINumber? actionState;
  SMINumber? characterHat;
  SMINumber? characterShield;
  SMINumber? characterColor;
  late StateMachineController? riveController;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _characterCard(int length, String roomId, String uid) {
    print('카드 빌드');
    return SizedBox(
      width: 210 - length * 18,
      height: 210 - length * 18,
      child: StreamBuilder(
        stream: RoomStreamRepository.getRoomStreamAsStream(roomId, uid)
            .debounceTime(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('스트림 로딩중 ${widget.index}');
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('불러오는 중 에러가 발생했습니다.');
          } else {
            print('스트림 완료 ${widget.index}');
            if (!isFirstLoad) {
              riveCharacterInit(snapshot.data!);
            }
            return RiveAnimation.direct(
              widget.riveFile,
              stateMachines: const ["character"],
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
    actionState = riveController!.findInput<double>('action') as SMINumber;
    characterHat = riveController!.findInput<double>('hat') as SMINumber;
    characterShield = riveController!.findInput<double>('shield') as SMINumber;
    characterColor = riveController!.findInput<double>('color') as SMINumber;
    riveCharacterInit(roomStreamModel);
  }

  void riveCharacterInit(RoomStreamModel roomStreamModel) {
    if (riveController != null) {
      CharacterModel characterModel = roomStreamModel.characterData!;
      actionState!.value = characterModel.actionState!.toDouble();
      characterHat!.value = characterModel.hat!.toDouble();
      characterShield!.value = characterModel.shield!.toDouble();
      characterColor!.value = characterModel.bodyColor!.toDouble();
    }
    isFirstLoad = false;
    print('캐릭터 init');
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
