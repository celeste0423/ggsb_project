import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
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

  Future<StudyTimeModel?> getLatestStudyTimeModel(String uid) async {
    try {
      QuerySnapshot timeDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('studyTime')
          .orderBy('createdAt', descending: true) // createdAt 기준으로 내림차순 정렬
          .limit(1) // 최신 데이터 한 개만 가져오기
          .get();

      if (timeDocs.docs.isNotEmpty) {
        // 시간 정보가 존재하면 가장 최신의 정보를 반환
        return StudyTimeModel.fromJson(
            timeDocs.docs.first.data() as Map<String, dynamic>);
      } else {
        // 시간 정보가 없으면 null 반환
        return null;
      }
    } catch (e) {
      // 오류 발생 시 경고창 표시
      openAlertDialog(
        title: '최신 시간 정보를 가져오는데 실패했습니다.',
        content: e.toString(),
      );
      return null; // 오류 발생 시 null 반환
    }
  }

  Future<List<StudyTimeModel>> getUncashedStudyTimeModelExceptToday(
      String uid) async {
    List<StudyTimeModel> uncashedStudyTimes = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('studyTime')
          .where('isCashed', isEqualTo: false)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in querySnapshot.docs) {
          String date = doc.id;
          // Check if the date is not equal to DateToday
          if (date != DateUtil().dateTimeToString(DateTime.now())) {
            uncashedStudyTimes.add(
              StudyTimeModel.fromJson(doc.data() as Map<String, dynamic>),
            );
          }
        }
      }
    } catch (e) {
      openAlertDialog(
        title: '시간 정보를 가져오는데 실패했습니다.',
        content: e.toString(),
      );
    }
    return uncashedStudyTimes;
  }

  Future<List<StudyTimeModel>> getStudyTimeInRange(
    String uid,
    DateTime startTime,
    DateTime endTime,
  ) async {
    List<StudyTimeModel> studyTimeModels = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('studyTime') // 적절한 컬렉션 경로로 변경해야 합니다.
          .where('createdAt', isGreaterThanOrEqualTo: startTime)
          .where('createdAt', isLessThanOrEqualTo: endTime)
          .get();
      studyTimeModels = querySnapshot.docs.map(
        (doc) {
          return StudyTimeModel.fromJson(doc.data() as Map<String, dynamic>);
        },
      ).toList();
    } catch (e) {
      openAlertDialog(
        title: '시간 정보를 가져오는데 실패했습니다.',
        content: e.toString(),
      );
    }
    return studyTimeModels;
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
        // print('날짜 ${DateUtil().dateTimeToString(date)}');
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
            uid: AuthController.to.user.value.uid,
            nickname: AuthController.to.user.value.nickname,
            date: DateUtil().dateTimeToString(date),
            totalSeconds: 0,
            isCashed: true,
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
