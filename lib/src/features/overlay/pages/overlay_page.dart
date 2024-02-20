import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';
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
            const Text(
              '시간 측정중에는\n앱을 종료하실 수 없습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.blackText,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: MainButton(
                buttonText: '앱으로 돌아가기',
                onTap: () async {
                  Restart.restartApp();
                  await FlutterOverlayWindow.closeOverlay();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
