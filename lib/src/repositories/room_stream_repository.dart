import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';

class RoomStreamRepository {
  Future<RoomStreamModel> getRoomStream(String roomId, String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('roomStream')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return RoomStreamModel.fromJson(
            snapshot.data() as Map<String, dynamic>);
      } else {
        return Future.error('RoomStream이 없음');
      }
    } catch (e) {
      openAlertDialog(
        title: '방 정보를 가져오는 중에 오류가 발생했습니다.',
        content: e.toString(),
      );
      return Future.error('방 정보를 가져오는 중에 오류가 발생했습니다.');
    }
  }

  Future<void> uploadRoomStream(
    RoomStreamModel roomStreamModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomStreamModel.roomId)
          .collection('roomStream')
          .doc(roomStreamModel.uid)
          .set(roomStreamModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '룸 스트림 업로드 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Future<void> updateRoomStream(
    RoomStreamModel roomStreamModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomStreamModel.roomId)
          .collection('roomStream')
          .doc(roomStreamModel.uid)
          .update(roomStreamModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '룸 스트림 업데이트 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Future<void> deleteRoomStream(String roomId, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('roomStream')
          .doc(uid)
          .delete();
    } catch (e) {
      openAlertDialog(
        title: '룸 스트림 삭제 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Stream<List<RoomStreamModel>> roomStreamListStream(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('roomStream')
        .orderBy('totalSeconds', descending: true)
        .snapshots()
        .map((event) {
      List<RoomStreamModel> roomStreams = [];
      for (var roomStream in event.docs) {
        roomStreams.add(RoomStreamModel.fromJson(roomStream.data()));
      }
      return roomStreams;
    });
  }
}
