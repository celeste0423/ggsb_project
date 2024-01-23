import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class MainButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color? buttonColor;
  Color? textColor;
  double? width;
  double? height;

  MainButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 45,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: buttonColor ?? CustomColors.mainBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 0),
                blurRadius: 5,
              ),
            ]),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 18,
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
