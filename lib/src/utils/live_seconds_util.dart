import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

import 'seconds_util.dart';

class LiveSecondsUtil {
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

  int whetherTimerZeroInInt(
    RoomStreamModel liveRoomStreamModel,
    RoomModel roomModel,
    DateTime now,
  ) {
    if (roomModel.roomType == 'day' &&
        DateUtil.calculateDateDifference(
              liveRoomStreamModel.lastTime ?? now,
              now,
            ) >=
            1) {
      return 0;
    }
    return liveRoomStreamModel.totalLiveSeconds!;
  }
}
