import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

class StudyTimeRepository {
  Future<StudyTimeModel?> getStudyTimeModel(String uid, String date) async {
    try {
      DocumentSnapshot timeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('studyTime')
          .doc(date)
          .get();
      if (timeDoc.exists) {
        return StudyTimeModel.fromJson(timeDoc.data()! as Map<String, dynamic>);
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

  Future<void> uploadStudyTimeModel(
    StudyTimeModel studyTimeModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(studyTimeModel.uid)
          .collection('studyTime')
          .doc(studyTimeModel.date)
          .set(studyTimeModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '스터디타임모델 업로드 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Future<void> updateStudyTimeModel(
    StudyTimeModel studyTimeModel,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(studyTimeModel.uid)
          .collection('studyTime')
          .doc(studyTimeModel.date)
          .update(studyTimeModel.toJson());
    } catch (e) {
      openAlertDialog(
        title: '스터디타임모델 업데이트 중 오류 발생',
        content: e.toString(),
      );
    }
  }

  Stream<List<StudyTimeModel>> studyTimeListStream(String uid, DateTime now) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('studyTime')
        .orderBy('date', descending: true)
        .limit(7)
        .snapshots()
        .map((event) {
      List<StudyTimeModel> timeModels = [];
      for (var studyTimeData in event.docs) {
        StudyTimeModel studyTimeModel =
            StudyTimeModel.fromJson(studyTimeData.data());
        timeModels.add(studyTimeModel);
      }
      // 오늘부터 7일 전까지의 날짜에 해당하는지 검사하여 필요한 경우에 추가
      List<StudyTimeModel> newTimeModels = [];
      DateTime endDate = now.subtract(Duration(days: 6));
      for (int i = 0; i < 7; i++) {
        DateTime date = endDate.add(Duration(days: i));
        print('날짜 ${DateUtil().dateTimeToString(date)}');
        bool found = false;
        for (var model in timeModels) {
          if (model.date == DateUtil().dateTimeToString(date)) {
            found = true;
            newTimeModels.add(model);
            break;
          }
        }
        if (!found) {
          // 해당하는 날짜의 데이터가 없는 경우 새로운 StudyTimeModel을 생성하여 추가
          StudyTimeModel newModel = StudyTimeModel(
            date: DateUtil().dateTimeToString(date),
            totalSeconds: 0,
          );
          newTimeModels.add(newModel);
        }
      }

      // 최신순으로 정렬하여 반환
      print('스터디타임리스트모델 개수 ${newTimeModels.length}');
      return newTimeModels;
    });
  }

// Stream<List<StudyTimeModel>> timeListStream(String uid) {
//   return FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('time')
//       .orderBy('day')
//       .snapshots()
//       .map((event) {
//     List<StudyTimeModel> timeModels = [];
//     for (var studyTimeModel in event.docs) {
//       timeModels.add(StudyTimeModel.fromJson(studyTimeModel.data()));
//     }
//     return timeModels;
//   });
// }
}
