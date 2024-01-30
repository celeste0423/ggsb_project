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
        openAlertDialog(
          title: '방 리스트 불러오기에 실패했습니다.',
          content: e.toString(),
        );
      }
    }
    return roomList;
  }

  Future<RoomModel?> getRoomModel(String roomId) async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();
      print('방 찾는 중 ${roomDoc.exists}');
      if (roomDoc.exists) {
        return RoomModel.fromJson(roomDoc.data()! as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      openAlertDialog(title: '방 정보 가져오기에 실패했습니다.');
    }
  }

  Future<void> updateRoomModel(RoomModel roomModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomModel.roomId)
          .update(roomModel.toJson());
    } catch (e) {
      openAlertDialog(title: '방 정보 업데이트에 실패했습니다', content: e.toString());
    }
  }

  Future<void> deleteRoomModel(RoomModel roomModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomModel.roomId)
          .collection('roomStream')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomModel.roomId)
          .delete();
    } catch (e) {
      openAlertDialog(title: '방 삭제에 실패했습니다.', content: e.toString());
    }
  }

  Future<void> removeUid(String roomId, String uidToRemove) async {
    RoomModel? roomModel = await getRoomModel(roomId);
    if (roomModel != null) {
      List<String> updatedUidList = List<String>.from(roomModel.uidList!);
      updatedUidList.remove(uidToRemove);
      try {
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomModel.roomId)
            .update({'uidList': updatedUidList});
      } catch (e) {
        // 업데이트 중 오류 발생 처리
        print('Error updating user data: $e');
      }
    } else {
      openAlertDialog(title: '방 정보가 없습니다.');
    }
  }
}
