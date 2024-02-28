import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/result/controllers/result_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

class ResultPage extends GetView<ResultPageController> {
  const ResultPage({super.key});

  // PreferredSizeWidget _appBar() {
  //   return AppBar(
  //     backgroundColor: CustomColors.mainBlue,
  //     centerTitle: true,
  //     title: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 20.0),
  //       child: SvgPicture.asset(
  //         'assets/images/caption_logo.svg',
  //         // color: CustomColors.whiteBackground,
  //       ),
  //     )
  //   );
  // }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              child: SvgPicture.asset('assets/images/caption_logo.svg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: CustomColors.whiteBackground,
          ),
          child: Column(
            children: [
              Text(
                '${DateFormat('yyyy - MM - dd').format(DateTime.now())}',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 15),
              // RiveAnimation.asset(
              //   'assets/riv/character.riv',
              //   stateMachines: ["character"],
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ResultPageController());
    return Scaffold(
      backgroundColor: CustomColors.mainBlue,
      body: Center(
          child: Column(
        children: [
          _title(),
          _resultBox(),
        ],
      )),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
// import 'package:ggsb_project/src/features/result/controllers/result_page_controller.dart';
// import 'package:ggsb_project/src/models/study_time_model.dart';
// import 'package:ggsb_project/src/models/user_model.dart';
// import 'package:ggsb_project/src/repositories/study_time_repository.dart';
// import 'package:ggsb_project/src/utils/custom_color.dart';
// import 'package:intl/intl.dart';
//
// class ResultPage extends GetView<ResultPageController> {
//   const ResultPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.mainBlue,
//       body: Center(
//         child: Column(
//           children: [
//             _buildTitle(),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return CircularProgressIndicator();
//                 } else {
//                   return _buildResultBox(controller.userStudyTimes);
//                 }
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTitle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 50.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SafeArea(
//             child: Container(
//               child: SvgPicture.asset('assets/images/caption_logo.svg'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildResultBox(List<StudyTimeModel> userStudyTimes) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 36.0),
//       child: Expanded(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             color: CustomColors.whiteBackground,
//           ),
//           child: Column(
//             children: [
//               Text(
//                 '${DateFormat('yyyy - MM - dd').format(DateTime.now())}',
//                 style: TextStyle(fontSize: 10),
//               ),
//               SizedBox(height: 15),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: userStudyTimes.length,
//                 itemBuilder: (context, index) {
//                   return _buildStudyTimeItem(userStudyTimes[index]);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStudyTimeItem(StudyTimeModel studyTime) {
//     return ListTile(
//       title: Text('User ID: ${AuthController.to.user.value}'),
//       subtitle: Text('Study Time: ${studyTime.totalSeconds} seconds'),
//     );
//   }
// }
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
//       final studyTimes = await _repository.getStudyTimeModel(uid, formattedDate);
//       // if (studyTimes != null) {
//       //   userStudyTimes.assignAll(studyTimes);
//       // }
//     } catch (e) {
//       print('Error fetching study times: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


