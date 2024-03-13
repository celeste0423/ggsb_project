import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/widgets/character.dart';

class CharacterList extends StatelessWidget {
  final RoomModel roomModel;

  const CharacterList({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PieChart(
        //   PieChartData(
        //     centerSpaceRadius: (Get.width - 100) / 2 - 40,
        //     borderData: FlBorderData(show: false),
        //     sections: _chartData(),
        //   ),
        // ),
        CircularMotion(
          children: List.generate(roomModel.uidList!.length, (index) {
            return Character(
              roomStreamId: roomModel.uidList![index],
              roomId: roomModel.roomId!,
              length: roomModel.uidList!.length,
            );
          }),
        ),
        // Character(
        //   roomStreamId: widget.roomModel.uidList![0],
        //   roomId: widget.roomModel.roomId!,
        //   length: widget.roomModel.uidList!.length,
        // ),
      ],
    );
  }
}
