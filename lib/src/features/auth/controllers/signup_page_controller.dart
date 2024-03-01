import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/constants/service_urls.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/room_model.dart';
import 'package:ggsb_project/src/models/room_stream_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/repositories/room_repository.dart';
import 'package:ggsb_project/src/repositories/room_stream_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

class SignupPageController extends GetxController {
  bool? isProfileEditing = Get.arguments;

  Rx<String> uid = ''.obs;
  Rx<String> email = ''.obs;
  String loginType = '';

  SMINumber? characterHat;
  SMINumber? characterColor;

  Rx<bool> isSignupLoading = false.obs;

  TextEditingController nicknameController = TextEditingController();

  Rx<bool> isSchoolLoading = false.obs;
  String nullSchoolName = '학교를 검색하세요(선택)';
  late Rx<String> schoolName = nullSchoolName.obs;
  TextEditingController schoolSearchController = TextEditingController();
  String selectedSchoolType = 'elem_list';
  late RxList<dynamic> schoolNameList = [nullSchoolName].obs;

  Rx<bool> isMale = true.obs;

  Rx<bool> isTermAgreed = false.obs;
  Rx<bool> isMarketingAgreed = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await checkIsProfileLoading();
  }

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    // riveController!.isActive = false;
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
    _riveCharacterInit();
  }

  void _riveCharacterInit() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData ??
        CharacterModel(
          actionState: 0,
          hat: 0,
          shield: 0,
          bodyColor: 0,
          purchasedItem: [],
        );
    characterHat!.value = characterModel.hat!.toDouble();
    characterColor!.value = characterModel.bodyColor!.toDouble();
  }

  Future<void> checkIsProfileLoading() async {
    if (isProfileEditing != null) {
      nicknameController.text = AuthController.to.user.value.nickname!;
      schoolName.value = AuthController.to.user.value.school!;
      if (AuthController.to.user.value.gender == 'female') {
        isMale(false);
      }
    }
  }

  Future<List<String>> searchSchools(
    String searchQuery,
    String gubun,
  ) async {
    // API 엔드포인트
    String apiUrl =
        '${ServiceUrls.schoolApiRequestUrl}${dotenv.env['SCHOOL_API_SECRET_KEY']}&svcType=api&svcCode=SCHOOL&contentType=json&gubun=$gubun&searchSchulNm=$searchQuery';
    // HTTP GET 요청 보내기
    http.Response response = await http.get(Uri.parse(apiUrl));
    // HTTP 응답 확인
    if (response.statusCode == 200) {
      // JSON 데이터 파싱
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> content = data['dataSearch']['content'];
      // schoolName 필드 값만 추출하여 List<String>에 추가

      List<String> schoolInfos = [];
      for (var item in content) {
        String schoolInfo = '${item['schoolName']} (${item['region']})';
        schoolInfos.add(schoolInfo);
        // List<String> schoolNames = [];
        // for (var item in content) {
        //   schoolNames.add(item['schoolName']);
      }
      return schoolInfos;
    } else {
      // HTTP 요청이 실패한 경우 에러 처리
      throw openAlertDialog(
          title: '학교 정보 로드에 실패했습니다.',
          content: '에러코드: ${response.statusCode.toString()}');
    }
  }

  void checkLoginType() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<UserInfo> providerData = user.providerData;

      for (UserInfo userInfo in providerData) {
        String providerId = userInfo.providerId;
        switch (providerId) {
          case 'google.com':
            print('구글로 로그인했습니다.');
            loginType = 'google';
            break;
          case 'apple.com':
            print('애플로 로그인했습니다.');
            loginType = 'apple';
            break;
          case 'facebook.com':
            print('페이스북으로 로그인했습니다.');
            loginType = 'facebook';
            break;
          // 필요한 경우 다른 프로바이더도 추가할 수 있습니다.
          default:
            print('다른 방법으로 로그인했습니다.');
            loginType = 'guest';
        }
      }
    } else {
      print('로그인한 사용자가 없습니다.');
    }
  }

  void schoolSearchButton() async {
    isSchoolLoading(true);
    schoolNameList(
        await searchSchools(schoolSearchController.text, selectedSchoolType));
    print(schoolNameList.value);
    isSchoolLoading(false);
  }

  Future<void> signUpButton() async {
    isSignupLoading(true);
    checkLoginType();
    if (nicknameController.text == '') {
      isSignupLoading(false);
      openAlertDialog(title: '닉네임을 입력해주세요');
    } else if (!isTermAgreed.value) {
      isSignupLoading(false);
      openAlertDialog(title: '이용약관 및 개인정보처리방침에 동의해주세요');
    } else {
      CharacterModel baseCharacterData = CharacterModel(
        actionState: 0,
        bodyColor: 0,
        shield: 0,
        hat: 0,
        purchasedItem: [],
      );
      UserModel userData = UserModel(
        uid: uid.value,
        deviceToken: await AuthController.to.getDeviceToken(),
        nickname: nicknameController.text,
        loginType: loginType,
        email: email.value,
        gender: isMale.value ? 'male' : 'female',
        school: schoolName.value == nullSchoolName ? null : schoolName.value,
        isTimer: false,
        totalSeconds: 0,
        cash: 0,
        characterData: baseCharacterData,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isMarketingAgreed: isMarketingAgreed.value,
      );
      // 회원가입 처리
      await AuthController.to.signUp(userData);
      isSignupLoading(false);
    }
  }

  Future<void> profileEditButton() async {
    isSignupLoading(true);
    checkLoginType();
    if (nicknameController.text == '') {
      isSignupLoading(false);
      openAlertDialog(title: '닉네임을 입력해주세요');
    } else {
      //유저모델 업데이트
      UserModel userData = AuthController.to.user.value.copyWith(
        nickname: nicknameController.text,
        school: schoolName.value == nullSchoolName ? null : schoolName.value,
        gender: isMale.value ? 'male' : 'female',
        updatedAt: DateTime.now(),
      );
      await AuthController.to.updateUserModel(userData);
      //방모델들 업데이트
      List<RoomModel> userRoomList = await RoomRepository()
          .getRoomList(AuthController.to.user.value.roomIdList!);
      for (RoomModel roomModel in userRoomList) {
        if (roomModel.creatorUid! == AuthController.to.user.value.uid) {
          //내가 만든 방의 룸모델 업데이트
          RoomModel updatedRoomModel = roomModel.copyWith(
            creatorName: nicknameController.text,
          );
          RoomRepository().updateRoomModel(updatedRoomModel);
        }
        //룸스트림 업데이트
        RoomStreamModel roomStreamModel =
            await RoomStreamRepository().getRoomStream(
          roomModel.roomId!,
          AuthController.to.user.value.uid!,
        );
        RoomStreamModel updatedRoomStreamModel = roomStreamModel.copyWith(
          nickname: nicknameController.text,
        );
        RoomStreamRepository().updateRoomStream(updatedRoomStreamModel);
      }
    }
  }
}
