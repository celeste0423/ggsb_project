import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/models/character_model.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:rive/rive.dart';

class CharacterList extends StatelessWidget {
  List<UserModel> userModelList;

  CharacterList({
    Key? key,
    required this.userModelList,
  }) : super(key: key);

  SMINumber? characterHat;
  SMINumber? characterColor;

  Widget _characterCard(int index) {
    return Container(
      width: 110,
      height: 110,
      child: RiveAnimation.asset(
        'assets/riv/character.riv',
        stateMachines: ["character"],
        onInit: onRiveInit,
      ),
    );
  }

  void onRiveInit(Artboard artboard) {
    final riveController =
        StateMachineController.fromArtboard(artboard, 'character');
    artboard.addController(riveController!);
    characterColor = riveController.findInput<double>('color') as SMINumber;
    characterHat = riveController.findInput<double>('hat') as SMINumber;
    riveCharacterInit();
  }

  void riveCharacterInit() {
    UserModel userModel = AuthController.to.user.value;
    CharacterModel characterModel = userModel.characterData!;
    characterHat!.value = characterModel.hat!.toDouble();
    characterColor!.value = characterModel.bodyColor!.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return CircularMotion.builder(
      itemCount: userModelList.length,
      builder: (context, index) {
        return _characterCard(index);
      },
    );
  }
}
