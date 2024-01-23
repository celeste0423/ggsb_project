// import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
// import 'package:flutter/material.dart';
//
// class AppleLoginButton extends StatelessWidget {
//   String? userid;
//
//   AppleLoginButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         await AuthController.to.signInWithApple();
//         // print('apple login 성공: nickname = ${AuthController.to.user.value.nickname}');
//         //로그인 타입 설정
//         AuthController.loginType = 'apple';
//       },
//       child: Stack(
//         children: [
//           Container(
//             height: 50,
//             decoration: BoxDecoration(
//               color: Color(0xFF000000),
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(),
//             ),
//             child: Center(
//               child: Text(
//                 'Apple로 로그인',
//                 style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontSize: 15,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 5,
//             top: 5,
//             child: Image.asset(
//               'assets/icons/apple.png',
//               height: 40,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
