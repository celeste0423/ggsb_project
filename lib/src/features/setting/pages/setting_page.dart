import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/setting/controllers/setting_page_controller.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/text_regular.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class SettingPage extends GetView<SettingPageController> {
  const SettingPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: false,
      leading: SvgIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: Get.back,
      ),
      title: Center(
        child: TitleText(
          text: '설정',
        ),
      ),
    );
  }


  Widget _buttons() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _titlebox('고객지원'),
          SizedBox(height: 10,),
          _button(
            '리뷰 남기기',
                () {},
          ),
          SizedBox(height: 10,),
          _linebox(),
          SizedBox(height: 10,),
          _button(
            '앱 버전',
                () {
            },
          ),
          SizedBox(height: 10,),
          _linebox(),
          SizedBox(height: 10,),
          _button(
            '이용약관',
                () {},
          ),
          SizedBox(height: 50,),
          _titlebox('계정'),
          SizedBox(height: 10,),
          _linebox(),
          SizedBox(height: 10,),
          _button(
            '연결된 계정',
                () {
            },
          ),
          SizedBox(height: 10,),
          _linebox(),
          SizedBox(height: 10,),
          _button(
            '로그아웃',
                () {
            },
          ),
          SizedBox(height: 10,),
          _linebox(),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _button(String text,  VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: CustomColors.blackText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }



  Widget _linebox(){
    return Center(
      child: Container(
        width: 330,
        height: 1,
        decoration: BoxDecoration(
          color: CustomColors.lightGreyText,
        ),
      ),
    );
  }

  Widget _titlebox(String text){
    return Row(
      children: [
        SizedBox(width: 10,),
        Text(
          text,
          style: TextStyle(
            color: CustomColors.blackText,
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
        )
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    Get.put(SettingPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buttons(),


            ],
          ),
        ),
      ),
    );
  }
}
  // Widget _supportBox() {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(top: 45, bottom: 10),
  //         child: TextRegular(
  //           text: text,
  //           style: TextStyle(
  //             color: isBlack ? Colors.black : CustomColors.redRoom,
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(top: 0),
  //         child: Container(
  //           width: 314,
  //           height: 1,
  //           color: CustomColors.lightGreyText,
  //         ),
  //       ),
  //     ],
  //   );
  // }


// class SettingPage extends GetView<SettingPageController> {
//   const SettingPage({super.key});
//
//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }
//
// class _SettingPageState extends State<SettingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: SvgIconButton(
//           assetName: 'assets/icons/back.svg',
//           onTap: Get.back,
//         ),
//         title: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 0),
//               child: TitleText(text: '설정'),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           _supportBox(),
//         ],
//       ),
//     );
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//   Get.put(SettingPageController());
//   return SafeArea(
//     child: Scaffold(
//         appBar: _appBar(),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//              SettingPage,
//               SizedBox(height: 85),
//             ],
//           ),
//         )),
//   );
// }

// Widget _supportBox() {
//   return Column(
//     children: [
//       Container(
//         padding: EdgeInsets.only(top: 45, bottom: 10),
//         child: TextRegular(text: '고객 지원'),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(top: 0),
//         child: Container(
//           width: 314,
//           height: 1,
//           color: CustomColors.lightGreyText,
//         ),
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: Text(
//           '리뷰 남기기',
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0),
//         child: Text(
//           '앱 버전',
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0),
//         child: Text(
//           '이용약관',
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0),
//         child: Text(
//           '계정',
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0),
//         child: Text(
//           '연결된 게정',
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0),
//         child: Text(
//           '로그아웃',
//           style: TextStyle(color: CustomColors.redRoom),
//         ),
//       ),
//       Container(
//         width: 314,
//         height: 1,
//         color: CustomColors.lightGreyText,
//       ),
//     ],
//   );
// }

