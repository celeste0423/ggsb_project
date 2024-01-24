import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class TitleText extends StatelessWidget {
  String text;
  Color? color;

  TitleText({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? CustomColors.blackText,
        fontSize: 25,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
