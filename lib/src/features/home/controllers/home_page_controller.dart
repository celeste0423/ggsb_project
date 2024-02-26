import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/room_create/pages/room_create_page.dart';
import 'package:ggsb_project/src/features/timer/pages/timer_page.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:ggsb_project/src/utils/seconds_util.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

class HomePageController extends GetxController {
  static HomePageController get to => Get.find();

  SMINumber? characterHat;
  SMINumber? characterColor;

  Rx<String> totalTime = '00:00:00'.obs;
  // Rx<String> totalHours = '00'.obs;
  // Rx<String> totalMinutes = '00'.obs;
  // Rx<String> totalSeconds = '00'.obs;

  Rx<String> today = DateFormat('M/d E', 'ko_KR').format(DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    // totalTime(
    //   SecondsUtil.convertToDigitString(
    //     AuthController.to.timeModel.value.totalSeconds ?? 0,
    //   ),
    // );
    totalTime(SecondsUtil.convertToDigitString(
        AuthController.to.studyTime.totalSeconds ?? 0));
    // countUpHours();
    // countUpMinutes();
    // countUpSeconds();
  }

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
    _riveCharacterInit();
  }

  void _riveCharacterInit() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData!;
    characterHat!.value = characterModel.hat!.toDouble();
    characterColor!.value = characterModel.bodyColor!.toDouble();
  }

  void tabCharacter() {
    if (characterColor!.value == 0) {
      characterColor!.value = 1;
    } else {
      characterColor!.value = 0;
    }
  }

  //시간 올라가는 애니메이션
  // Future<void> countUpHours() async {
  //   int i = 0;
  //   void count() {
  //     i++;
  //     if (i <=
  //         SecondsUtil.convertToHours(
  //             AuthController.to.timeModel.value.totalSeconds!)) {
  //       Timer(Duration(milliseconds: 100), count);
  //       String hour = SecondsUtil.digits(i);
  //       totalHours(hour);
  //     }
  //   }
  //
  //   count();
  // }
  //
  // Future<void> countUpMinutes() async {
  //   int i = 0;
  //   void count() {
  //     i++;
  //     if (i <=
  //         SecondsUtil.convertToMinutes(
  //             AuthController.to.timeModel.value.totalSeconds!)) {
  //       Timer(Duration(milliseconds: 30), count);
  //       String minutes = SecondsUtil.digits(i);
  //       totalMinutes(minutes);
  //     }
  //   }
  //
  //   count();
  // }
  //
  // Future<void> countUpSeconds() async {
  //   int i = 0;
  //   void count() {
  //     i++;
  //     if (i <=
  //         SecondsUtil.convertToSeconds(
  //             AuthController.to.timeModel.value.totalSeconds!)) {
  //       Timer(Duration(milliseconds: 30), count);
  //       String seconds = SecondsUtil.digits(i);
  //       totalSeconds(seconds);
  //     }
  //   }
  //
  //   totalSeconds(
  //     SecondsUtil.digits(
  //       SecondsUtil.convertToSeconds(
  //           AuthController.to.timeModel.value.totalSeconds!),
  //     ),
  //   );
  // }

  void addRoomButton() {
    Get.to(() => RoomCreatePage(), transition: Transition.rightToLeft);
  }

  void timerPageButton() {
    Get.to(() => TimerPage());
  }
}
