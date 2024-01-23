import 'package:flutter/material.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

Widget fullSizeLoadingIndicator() {
  return Container(
    color: Colors.white,
    child: Center(
      child: CircularProgressIndicator(
        color: CustomColors.mainBlue,
      ),
    ),
  );
}
