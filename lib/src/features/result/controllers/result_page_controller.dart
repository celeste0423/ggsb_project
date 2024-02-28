import 'package:get/get.dart';

class ResultPageController extends GetxController {
  static ResultPageController get to => Get.find();
}


// import 'package:get/get.dart';
// import 'package:ggsb_project/src/models/study_time_model.dart';
// import 'package:ggsb_project/src/models/user_model.dart';
// import 'package:ggsb_project/src/repositories/study_time_repository.dart';
//
// class ResultPageController extends GetxController {
//   final StudyTimeRepository _repository = StudyTimeRepository();
//   var isLoading = true.obs;
//   var userStudyTimes = <StudyTimeModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserStudyTimes();
//   }
//
//   void fetchUserStudyTimes() async {
//     try {
//       isLoading.value = true;
//       final UserModel currentUser = Get.arguments ?? UserModel(); // Get current user
//       final String uid = currentUser.uid ?? ''; // Get current user's UID
//       final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
//       final String formattedDate = DateFormat('yyyy-MM-dd').format(yesterday);
//
//       final studyTimes = await _repository.getStudyTimesForUserOnDate(uid, formattedDate);
//       if (studyTimes != null) {
//         userStudyTimes.assignAll(studyTimes);
//       }
//     } catch (e) {
//       print('Error fetching study times: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


