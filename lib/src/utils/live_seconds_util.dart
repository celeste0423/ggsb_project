import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

import 'seconds_util.dart';

class LiveSecondsUtil {
  static int deletionCriteria = 3600 * 17;

  RoomStreamModel calcTotalLiveSecInRoomStream(
    RoomStreamModel roomStreamModel,
    DateTime now,
  ) {
    late int liveTotalSeconds;

    if (DateUtil().calculateDateDifference(roomStreamModel.startTime!, now) ==
            0 ||
        roomStreamModel.isTimer!) {
      //마지막 공부 시작 시간이 오늘
      if (roomStreamModel.isTimer == false) {
        liveTotalSeconds = roomStreamModel.totalSeconds!;
      } else {
        int calcSec = SecondsUtil.calculateDifferenceInSeconds(
          roomStreamModel.startTime!,
          DateTime.now(),
        );
        if (calcSec > deletionCriteria) {
          //측정 시간이 17시간이 넘은 걸 발견했을 시 시간 기록 삭제
          deleteStudyTime(roomStreamModel);
          liveTotalSeconds = 0;
        } else {
          liveTotalSeconds = roomStreamModel.totalSeconds! + calcSec;
        }
        // liveTotalSeconds = roomStreamModel.totalSeconds! + calcSec;
      }
    } else {
      //마지막 공부 시작 시간이 오늘 이전일 경우 0 반환
      liveTotalSeconds = 0;
    }

    RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
      totalLiveSeconds: liveTotalSeconds,
    );
    return updatedRoomStreamModel;
  }

  void deleteStudyTime(RoomStreamModel roomStreamModel) async {
    UserModel? userModel =
        await UserRepository.getUserData(roomStreamModel.uid!);
    UserModel updatedUserModel = userModel!.copyWith(
      isTimer: false,
    );
    UserRepository().updateUserModel(updatedUserModel);
    RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
      isTimer: false,
      totalSeconds: 0,
    );
    RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
  }

//   int whetherTimerZeroInInt(
//     RoomStreamModel liveRoomStreamModel,
//     RoomModel roomModel,
//     DateTime now,
//   ) {
//     // print(
//     //     '날짜 차이 ${DateUtil().calculateDateDifference(liveRoomStreamModel.lastTime ?? now, now)}');
//     // print('마지막 날짜 ${liveRoomStreamModel.lastTime}');
//     if (roomModel.roomType == 'day' &&
//         DateUtil().calculateDateDifference(
//                 liveRoomStreamModel.lastTime ?? now, now) >=
//             1) {
//       return 0;
//     }
//     return liveRoomStreamModel.totalLiveSeconds!;
//   }
}
