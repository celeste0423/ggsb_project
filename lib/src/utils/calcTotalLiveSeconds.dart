import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';

class CalcTotalLiveSeconds {
  static RoomStreamModel calcTotalLiveSecInRoomStream(
      RoomStreamModel roomStreamModel) {
    late int liveTotalSeconds;
    if (roomStreamModel.isTimer == false) {
      liveTotalSeconds = roomStreamModel.totalSeconds!;
    } else {
      int calcSec = SecondsUtil.calculateDifferenceInSeconds(
        roomStreamModel.startTime!,
        DateTime.now(),
      );
      liveTotalSeconds = roomStreamModel.totalSeconds! + calcSec;
    }
    RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
      totalLiveSeconds: liveTotalSeconds,
    );
    return updatedRoomStreamModel;
  }
}
