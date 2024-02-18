import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._();

  //앱 대표 색 materialColor type
  static const MaterialColor mainBlueMaterial = MaterialColor(
    0xFF5FA3D4,
    <int, Color>{
      50: Color(0xFFE1EEF7),
      100: Color(0xFFB5D7F1),
      200: Color(0xFF89C1EB),
      300: Color(0xFF5CAAE4),
      400: Color(0xFF3B9CDE),
      500: Color(0xFF5FA3D4),
      600: Color(0xFF248FCC),
      700: Color(0xFF2184C4),
      800: Color(0xFF1D79BB),
      900: Color(0xFF1466AD),
    },
  );

  //앱 대표 색
  static const Color mainBlue = Color(0xFF5FA3D4);
  static const Color subLightBlue = Color(0xFF85AAD7);
  static const Color subPaleBlue = Color(0xFFE2F3FF);
  static const Color mainBlack = Color(0xFF212121);
  static const Color subRed = Color(0xFFF14B40);

  //텍스트 색
  static const Color blackText = Color(0xFF171717);
  static const Color darkGreyText = Color(0xFF2F2F2F);
  static const Color greyText = Color(0xFF7C7C7C);
  static const Color lightGreyText = Color(0xFFA8A8A8);
  static const Color whiteText = Color(0xFF7C7C7C);
  static const Color redText = Color(0xFFF14B40);

  //배경 색
  static const Color whiteBackground = Color(0xFFFFFFFF);
  static const Color lightGreyBackground = Color(0xFFF1F1F1);
  static const Color greyBackground = Color(0xFFBBBBBB);
  // static const Color blueBackground = Color(0xFF5FA3D4);

  //방 색
  static const Color redRoom = Color(0xFFF58181);
  static const Color orangeRoom = Color(0xFFFFB46E);
  static const Color yellowRoom = Color(0xFFEED787);
  static const Color lightGreenRoom = Color(0xFF93D25F);
  static const Color greenRoom = Color(0xFF749857);
  static const Color darkGreenRoom = Color(0xFF468B59);
  static const Color blueRoom = Color(0xFF5FA3D4);
  static const Color darkBlueRoom = Color(0xFF5F6BD4);
  static const Color purpleRoom = Color(0xFF9F63EB);
  static const Color brownRoom = Color(0xFF815B46);
  static const Color greyRoom = Color(0xFF5E5E5E);
  static const Color blackRoom = Color(0xFF212121);

  static String roomColorToName(Color color) {
    switch (color) {
      case redRoom:
        return 'redRoom';
      case orangeRoom:
        return 'orangeRoom';
      case yellowRoom:
        return 'yellowRoom';
      case lightGreenRoom:
        return 'lightGreenRoom';
      case greenRoom:
        return 'greenRoom';
      case darkGreenRoom:
        return 'darkGreenRoom';
      case blueRoom:
        return 'blueRoom';
      case darkBlueRoom:
        return 'darkBlueRoom';
      case purpleRoom:
        return 'purpleRoom';
      case brownRoom:
        return 'brownRoom';
      case greyRoom:
        return 'greyRoom';
      case blackRoom:
        return 'blackRoom';
      default:
        return '';
    }
  }

  static Color nameToRoomColor(String colorName) {
    switch (colorName) {
      case 'redRoom':
        return redRoom;
      case 'orangeRoom':
        return orangeRoom;
      case 'yellowRoom':
        return yellowRoom;
      case 'lightGreenRoom':
        return lightGreenRoom;
      case 'greenRoom':
        return greenRoom;
      case 'darkGreenRoom':
        return darkGreenRoom;
      case 'blueRoom':
        return blueRoom;
      case 'darkBlueRoom':
        return darkBlueRoom;
      case 'purpleRoom':
        return purpleRoom;
      case 'brownRoom':
        return brownRoom;
      case 'greyRoom':
        return greyRoom;
      case 'blackRoom':
        return blackRoom;
      default:
        return Color(0xFF000000);
    }
  }
}
