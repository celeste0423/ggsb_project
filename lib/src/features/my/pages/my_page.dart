import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/my/controllers/my_page_controller.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';
import 'package:ggsb_project/src/widgets/title_text_bold.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});


  PreferredSizeWidget _myBox() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: TitleText_bold(text:'My')
          ),
        ),
      ),
    );
  }

  Widget _nameBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 30),
      child: Row(
        children: [
          Container(
            width: 230,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Text(
                '사용자님 \n안녕하세요 :)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  fontFamily: 'nanum',
                ),
              ),
            ),
          ),
          SizedBox(width: 0), // 텍스트와 회색 원 사이 간격 조절
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              color: Color(0xffe9ecef),
            ),
          ),
        ],
      ),
    );
  }


  Widget _graphBox(){
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: 333 ,
        height: 166,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 3)
            )
          ]
        ),
      ),
    );
  }


  // Widget _timeBox() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5),
  //     child: Container(
  //       color: Colors.white,
  //       child: Text(
  //         '주간 공부시간',
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 15,
  //           fontFamily: 'nanum',
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //       child: Text(
  //         '120:00:00',
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 15,
  //           fontFamily: 'nanum',
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ),
  //   );
  // }


  Widget _timeBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 23),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주간 공부시간',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontFamily: 'nanum',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '120:00:00',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'nanum',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _infoBox() {
    BoxDecoration myDecoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 3)
          )
        ]
    );

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              decoration: myDecoration,
              width: 333,
              height: 59,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.content_paste_search_sharp,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Text(
                      '기록 분석',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'nanum',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(bottom: 30),
          //   child: Container(
          //     decoration: myDecoration,
          //     width: 333,
          //     height: 59,
          //     margin: EdgeInsets.all(10),
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 40),
          //         ,
          //           child: Text(
          //           '기록 분석',
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 13,
          //               fontWeight: FontWeight.w400,
          //               fontFamily: 'nanum'),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              color: Colors.black12,
              width: 99,
              height: 1,
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Container(
              decoration: myDecoration,
              width: 333,
              height: 59,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Text(
                      '설정',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'nanum',
                      ),
                    ),
                  ),
                ],
              ),
              // child: Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 20),
              //       child: Text(
              //         '설정',
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 13,
              //             fontWeight: FontWeight.w400,
              //             fontFamily: 'nanum'),
              //       ),
              //     ),
              //   ),
              ),
            ),

          Container(
            decoration: myDecoration,
            width: 333,
            height: 59,
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.report_gmailerrorred,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Text(
                    '문의하기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'nanum',
                    ),
                  ),
                ),
              ],
            ),
            // child: Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 20),
            //       child: Text(
            //         '문의하기',
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 13,
            //             fontWeight: FontWeight.w400,
            //             fontFamily: 'nanum'),
            //       ),
            //     ),
            // ),
          ),
        ],
      ),
    );
  }

// Widget _infoBox(){
//     return Container(
//       child: Column(
//         children: [
//           Container(
//
//           ),
//           Container(
//
//           ),
//           Container(
//
//           ),
//
//         ],
//       ),
//     );
// }


  // Widget _nameBox() {
  //   return  Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 150, top: 50),
  //         child: Container(
  //           color: Colors.grey,
  //           child: Text(
  //             '사용자님, \n안녕하세요',
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 25,
  //               fontFamily: 'nanum',
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }




  // Widget _nameBox() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 30),
  //     child: Container(
  //       width: 300,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         color: Colors.grey,
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 20, right: 20),
  //         child: Text(
  //               '사용자님 안녕하세요!',
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 20,
  //                   fontFamily: 'nanum'
  //               ),
  //             ),
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    Get.put(MyPageController());
    return SafeArea(
      child: Scaffold(
        appBar: _myBox(),
        body: Column(
          children: [
            _nameBox(),
            _graphBox(),
            _timeBox(),
            _infoBox(),
          ],
        )
      ),
    );
  }
}
