import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/widgets/character.dart';
import 'package:rive/rive.dart';

class CharacterList extends StatelessWidget {
  final RoomModel roomModel;
  final RiveFile riveFile;

  const CharacterList({
    Key? key,
    required this.roomModel,
    required this.riveFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(roomModel.uidList!.length * 3),
      child: CircularMotion(
        children: List.generate(roomModel.uidList!.length, (index) {
          return Character(
            roomStreamId: roomModel.uidList![index],
            roomId: roomModel.roomId!,
            length: roomModel.uidList!.length,
            index: index,
            riveFile: riveFile,
          );
        }),
      ),
    );
  }
}
