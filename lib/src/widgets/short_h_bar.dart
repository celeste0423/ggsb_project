import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class ShortHBar extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const ShortHBar({
    Key? key,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 5,
      width: width ?? 35,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: color ?? CustomColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
