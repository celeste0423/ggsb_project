import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class MainButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  Color? backgroundColor;
  TextStyle? textStyle;
  double? width;
  double? height;
  Widget? icon;

  MainButton(
      {Key? key,
      required this.buttonText,
      required this.onTap,
      this.backgroundColor,
      this.textStyle,
      this.width,
      this.height,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
          width: width,
          height: height ?? 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor ?? CustomColors.mainBlue,
          ),
          child: icon == null
              ? Center(
                  child: Text(
                    buttonText,
                    style: textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon!,
                    const SizedBox(width: 10),
                    Text(
                      buttonText,
                      style: textStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                    ),
                  ],
                )),
    );
  }
}

