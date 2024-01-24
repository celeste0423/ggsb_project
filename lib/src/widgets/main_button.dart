import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class MainButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color? buttonColor;
  TextStyle? textStyle;
  double? width;
  double? height;

  MainButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textStyle,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: width,
        height: height ?? 55,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: buttonColor ?? CustomColors.mainBlue,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
          ),
        ),
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
