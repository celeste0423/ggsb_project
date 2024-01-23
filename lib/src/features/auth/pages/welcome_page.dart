import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/welcome_page_controller.dart';
import 'package:ggsb_project/src/features/auth/widgets/google_login_button.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class WelcomePage extends GetView<WelcomePageController> {
  const WelcomePage({super.key});

  Widget _logo() {
    return Center(
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 3, right: 5),
          child: Text(
            '공부로 대결하는\n한판 진검승부',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        SvgPicture.asset(
          'assets/images/caption.svg',
          width: 175,
          height: 45,
        )
      ],
    );
  }

  Widget _bottomTab() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleLoginButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomePageController());
    return Scaffold(
        backgroundColor: CustomColors.mainBlue,
        body: Column(
          children: [
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            Expanded(flex: 2, child: _logo()),
            Expanded(flex: 3, child: _title()),
            _bottomTab()
          ],
        ));
  }
}
