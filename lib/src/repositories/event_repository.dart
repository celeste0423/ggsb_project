import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/event_model.dart';

class EventRepository {
  Future<void> createEvent(EventModel eventModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventModel.title)
          .set(eventModel.toJson());
    } catch (e) {
      openAlertDialog(title: '이벤트 생성에 실패했습니다.', content: e.toString());
    }
  }

  Future<List<EventModel>> getEventList() async {
    List<EventModel> events = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .orderBy('createdAt', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((document) {
          EventModel event =
              EventModel.fromJson(document.data() as Map<String, dynamic>);
          events.add(event);
        });
      }
    } catch (e) {
      openAlertDialog(
        title: '이벤트 불러오기에 실패했습니다.',
        content: e.toString(),
      );
    }
    return events;
  }

  Future<void> deleteEventModel(EventModel eventModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventModel.title)
          .delete();
    } catch (e) {
      openAlertDialog(title: '이벤트 삭제에 실패했습니다.', content: e.toString());
    }
  }
}
