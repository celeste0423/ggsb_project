import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class TitleText extends StatelessWidget {
  String text;
  Color? color;
  double? fontSize;

  TitleText({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: TextStyle(
          color: color ?? CustomColors.blackText,
          fontSize: fontSize ?? 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
