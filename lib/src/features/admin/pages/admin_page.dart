import 'package:flutter/material.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/repositories/user_repository.dart';
import 'package:ggsb_project/src/widgets/main_button.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 페이지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              MainButton(
                buttonText: '알림 보내기',
                backgroundColor: Colors.grey,
                onTap: () {
                  openAlertDialog(title: '기능 추가중');
                },
              ),
              MainButton(
                buttonText: '로그아웃',
                backgroundColor: Colors.red,
                onTap: () async {
                  await UserRepository.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
