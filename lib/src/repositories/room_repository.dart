import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/room_model.dart';

class RoomRepository {
  static Future<void> createRoom(RoomModel roomModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(roomModel.roomId)
          .set(roomModel.toJson());
    } catch (e) {
      openAlertDialog(title: '방 생성에 실패했습니다.', content: e.toString());
    }
  }
}
