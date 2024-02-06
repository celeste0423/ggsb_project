import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Rx<UserModel> user = UserModel().obs;
  // static String? loginType;

  // Rx<TimeModel> timeModel = TimeModel().obs;
  StudyTimeModel studyTime = StudyTimeModel();

  Future<UserModel?> loginUser(String uid) async {
    UserModel? userData = await UserRepository.getUserData(uid);
    if (userData != null) {
      //매번 업데이트 되는 userData
      //deviceToken 업로드
      String? token = await getDeviceToken();
      userData.copyWith(deviceToken: token);

      //authcontroller user 업데이트
      user(userData);

      //스터디타임모델 업데이트
      await updateStudyTimeModel(uid);

      InitBinding.additionalBinding();
    }
    return userData;
  }

  // Future<void> updateTimeModel(String uid) async {
  //   var timeData = await TimeRepository().getTimeModel(
  //     uid,
  //     DateUtil.getDayOfWeek(DateTime.now()),
  //   );
  //   if (timeData != null) {
  //     if (DateUtil()
  //             .calculateDateDifference(timeData.lastTime!, DateTime.now()) >
  //         4) {
  //       timeData = timeData.copyWith(
  //         totalSeconds: 0,
  //       );
  //     }
  //     timeModel(timeData);
  //   }
  // }

  Future<void> updateStudyTimeModel(String uid) async {
    print('스터디타임모델 업데이트');
    StudyTimeModel? studyTimeData =
        await StudyTimeRepository().getStudyTimeModel(
      uid,
      DateUtil().dateTimeToString(DateTime.now()),
    );
    if (studyTimeData == null) {
      print('스터디타임모델 없음 아직');
      //만약 없으면 새로 만들기
      StudyTimeModel newStudyTimeModel = StudyTimeModel(
        uid: user.value.uid,
        date: DateUtil().dateTimeToString(DateTime.now()),
        totalSeconds: 0,
        startTime: null,
        lastTime: null,
      );
      StudyTimeRepository().uploadStudyTimeModel(newStudyTimeModel);
      studyTime = newStudyTimeModel;
    } else {
      //있으면 기존 모델 업데이트
      studyTime = studyTimeData;
    }
  }

  Future<UserModel?> updateAuthController(String uid) async {
    // print('로그인 중');
    var userData = await UserRepository.getUserData(uid);
    // print('유저 데이터 ${userData}');
    if (userData != null) {
      user(userData);
      InitBinding.additionalBinding();
    }
    return userData;
  }

  Future<void> updateUserModel(UserModel userModel) async {
    print('유저모델 업데이트 ${userModel.isTimer}');
    user(userModel);
    await UserRepository().updateUserModel(userModel);
  }

  Future<String?> getDeviceToken() async {
    // String? token = await FirebaseMessaging.instance.getToken();
    String? token = null;
    return token;
  }

  // 애플 로그인
  Future<UserCredential> signInWithApple() async {
    bool isAvailable = await SignInWithApple.isAvailable();
    print('애플 로그인 isAvailable: ${isAvailable}');

    if (isAvailable) {
      return await UserRepository.iosSignInWithApple();
    } else {
      return await UserRepository.appleFlutterWebAuth();
    }
  }

  //구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    return await UserRepository.signInWithGoogle();
  }

  //페이스북 로그인
  Future<UserCredential> signInWithFacebook() async {
    return await UserRepository.signInWithFacebook();
  }

  //회원가입
  Future<void> signUp(UserModel userData) async {
    await UserRepository.signup(userData);
    await loginUser(userData.uid!);
    print('uid야 ${user.value.uid}');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    user();
    // studyTime == null;
  }
}
