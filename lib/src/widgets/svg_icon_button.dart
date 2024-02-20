import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class ImageIconButton extends StatelessWidget {
  String assetPath;
  VoidCallback onTap;
  Color? iconColor;
  double? height;
  bool? isPng;

  ImageIconButton({
    Key? key,
    required this.assetPath,
    required this.onTap,
    this.iconColor,
    this.height,
    this.isPng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: isPng != null
          ? Image.asset(
              assetPath,
              height: height,
              color: iconColor ?? CustomColors.greyBackground,
            )
          : SvgPicture.asset(
              assetPath,
              height: height,
              color: iconColor ?? CustomColors.greyBackground,
            ),
    );
  }
}

// Widget mainButton(
//   String text,
//   Function()? onPressed,
//     [double? x, Color? color]
// ) {
//   return SizedBox(
//     height: 50,
//     width: x ?? double.infinity,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color, // Background color
//       ),
//       onPressed: onPressed,
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 35, color: Colors.white),
//       ),
//     ),
//   );
// }
