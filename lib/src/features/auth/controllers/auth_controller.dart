import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/binding/init_binding.dart';
import 'package:ggsb_project/src/features/store/controllers/store_page_controller.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:ggsb_project/src/repositories/study_time_repository.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      //스터디타임모델, adCount 업데이트
      await updateStudyTimeModelAdCount(uid);

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

  Future<void> updateStudyTimeModelAdCount(String uid) async {
    print('스터디타임모델 업데이트');
    DateTime now = DateTime.now();
    StudyTimeModel? studyTimeData =
        await StudyTimeRepository().getStudyTimeModel(
      uid,
      DateUtil().dateTimeToString(now),
    );
    if (studyTimeData == null) {
      print('스터디타임모델 없음 아직');
      //만약 없으면 새로 만들기
      StudyTimeModel newStudyTimeModel = StudyTimeModel(
        uid: user.value.uid,
        date: DateUtil().dateTimeToString(now),
        totalSeconds: 0,
        startTime: DateUtil.standardRefreshTime(now),
        //다음날 들어온 사람 때문에
        lastTime: null,
      );
      StudyTimeRepository().uploadStudyTimeModel(newStudyTimeModel);
      studyTime = newStudyTimeModel;
      //광고 보기 횟수 초기화
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('rewardedAdCount', StorePageController.totalAdCount);
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
    user(userModel);
    await UserRepository().updateUserModel(userModel);
  }

  Future<void> updateCharacterModel(
    CharacterModel characterModel,
    UserModel userModel,
  ) async {
    UserModel updatedUserModel = userModel.copyWith(
      characterData: characterModel,
    );
    user(updatedUserModel);
    await UserRepository().updateUserModel(updatedUserModel);
    //방모델들 업데이트
    List<RoomModel> userRoomList =
        await RoomRepository().getRoomList(userModel.roomIdList!);
    for (RoomModel roomModel in userRoomList) {
      //룸스트림 업데이트
      RoomStreamModel roomStreamModel =
          await RoomStreamRepository().getRoomStream(
        roomModel.roomId!,
        userModel.uid!,
      );
      RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
        characterData: characterModel,
      );
      RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
    }
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

  //게스트 로그인
  Future signInWithGuest(String email, String password) async {
    await UserRepository().signUpWithEmailAndPassword(email, password);
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
