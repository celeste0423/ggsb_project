import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class TitleText_bold extends StatelessWidget {
  String text;
  Color? color;

  TitleText_bold({
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
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
