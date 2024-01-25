import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/widgets/text_regular.dart';
import 'package:ggsb_project/src/widgets/title_text_bold.dart';



class SettingFocus extends StatefulWidget {
  const SettingFocus({super.key});

  @override
  State<SettingFocus> createState() => _SettingFocusState();
}
class _SettingFocusState extends State<SettingFocus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.arrow_back_outlined,
              size: 25,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: TitleText_bold(text: '설정'),
            ),
          ),
        ),
      ),
    );
  }
}
Widget _supportBox() {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(8.0),
        child: TextRegular(text: '고객 지원'),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.green,
        child: Text(
          'Text 2',
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.orange,
        child: Text(
          'Text 3',
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.purple,
        child: Text(
          'Text 4',
          style: TextStyle(color: Colors.white),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.red,
        child: Text(
          'Text 5',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}

@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // appBar: _settingBox(),
          body: Column(
            children: [
              _supportBox(),

            ],
          )
      ),
    );
  }

