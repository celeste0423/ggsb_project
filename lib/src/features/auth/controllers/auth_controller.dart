import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/models/time_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/time_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Rx<UserModel> user = UserModel().obs;
  static String? loginType;

  Rx<TimeModel> timeModel = TimeModel().obs;

  Future<UserModel?> loginUser(String uid) async {
    var userData = await UserRepository.getUserData(uid);
    if (userData != null) {
      // print('유저 데이터 ${userData.toJson()}');
      user(userData);

      //타임모델 업데이트
      await updateTimeModel(uid);
      InitBinding.additionalBinding();
    }
    return userData;
  }

  Future<void> updateTimeModel(String uid) async {
    var timeData = await TimeRepository().getTimeModel(
      uid,
      DateUtil.getDayOfWeek(DateTime.now()),
    );
    if (timeData != null) {
      if (DateUtil.calculateDateDifference(timeData.lastTime!, DateTime.now()) >
          4) {
        timeData = timeData.copyWith(
          totalSeconds: 0,
        );
      }
      timeModel(timeData);
    }
  }

  // void updateOfflineTimeModel(TimeModel newTimeModel) {
  //   timeModel(newTimeModel);
  // }

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

  // 애플 로그인
  // Future<UserCredential> signInWithApple() async {
  //   bool isAvailable = await SignInWithApple.isAvailable();
  //
  //   if (isAvailable) {
  //     return await UserRepository.iosSignInWithApple();
  //   } else {
  //     return await UserRepository.appleFlutterWebAuth();
  //   }
  // }

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
    //timeModel 업로드
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    for (String day in days) {
      TimeModel timeModel = TimeModel(
        uid: userData.uid,
        day: day,
        totalSeconds: 0,
        isTimer: false,
        startTime: DateTime.now(),
        lastTime: DateTime.now(),
      );
      await TimeRepository().uploadTimeModel(timeModel);
    }
    await loginUser(userData.uid!);
    print('uid야 ${user.value.uid}');
    print('total time이야 ${timeModel.value.totalSeconds}');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    user();
    timeModel();
  }
}
