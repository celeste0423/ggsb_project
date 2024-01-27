import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/time_model.dart';

class TimeRepository {
  Future<TimeModel?> getTimeModel(String uid, String day) async {
    try {
      DocumentSnapshot timeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('time')
          .doc(day)
          .get();
      if (timeDoc.exists) {
        return TimeModel.fromJson(timeDoc.data()! as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      openAlertDialog(
        title: '시간 정보를 가져오는데 실패했습니다.',
        content: e.toString(),
      );
    }
  }

  Future<void> uploadTimeModel(
    TimeModel timeModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(timeModel.uid)
          .collection('time')
          .doc(timeModel.day)
          .set(timeModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '타임모델 업로드 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Future<void> updateTimeModel(
    TimeModel timeModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(timeModel.uid)
          .collection('time')
          .doc(timeModel.day)
          .update(timeModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '타임모델 업데이트 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Stream<List<TimeModel>> roomListStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('roomStream')
        .orderBy('totalSeconds')
        .snapshots()
        .map((event) {
      List<TimeModel> roomStreams = [];
      for (var roomStream in event.docs) {
        roomStreams.add(TimeModel.fromJson(roomStream.data()));
      }
      return roomStreams;
    });
  }
}
