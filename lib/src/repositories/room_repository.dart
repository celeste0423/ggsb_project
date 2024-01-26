import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';

class RoomRepository {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('rooms');

  Future<void> createRoom(RoomModel roomModel) async {
    try {
      await collection.doc(roomModel.roomId).set(roomModel.toJson());
    } catch (e) {
      openAlertDialog(title: '방 생성에 실패했습니다.', content: e.toString());
    }
  }

  Future<List<RoomModel>> getRoomList(List<String> roomIdList) async {
    List<RoomModel> roomList = [];
    for (String roomId in roomIdList) {
      try {
        // 방 정보 가져오기
        DocumentSnapshot roomDoc = await collection.doc(roomId).get();
        // 방 정보가 존재하는 경우 Room 객체로 변환하여 리스트에 추가
        if (roomDoc.exists) {
          RoomModel roomModel =
              RoomModel.fromJson(roomDoc.data() as Map<String, dynamic>);
          roomList.add(roomModel);
        }
      } catch (e) {
        openAlertDialog(title: '방 불러오기에 실패했습니다.', content: e.toString());
      }
    }
    return roomList;
  }

  Future<RoomModel> getRoomModel(String roomId) async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();
      if (roomDoc.exists) {
        return RoomModel.fromJson(roomDoc.data()! as Map<String, dynamic>);
      } else {
        return Future.error('Room not found');
      }
    } catch (e) {
      print('방 정보 가져오기에 실패했습니다. $e');
      return Future.error('Failed to get room data');
    }
  }

  Future<void> updateRoomModel(RoomModel roomModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomModel.roomId)
          .update(roomModel.toJson());
    } catch (e) {
      openAlertDialog(title: '오류 발생', content: e.toString());
    }
  }
}
