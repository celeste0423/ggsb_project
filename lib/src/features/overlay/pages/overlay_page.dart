import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:restart_app/restart_app.dart';

class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '시간 측정중에는 앱을 종료하실 수 없습니다.',
              style: TextStyle(
                color: CustomColors.blackText,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            CupertinoButton(
              onPressed: () async {
                Restart.restartApp();
                await FlutterOverlayWindow.closeOverlay();
              },
              child: Container(
                width: 100,
                height: 50,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
