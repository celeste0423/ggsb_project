import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as facebook;
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/helpers/open_alert_dialog.dart';
import 'package:ggsb_project/src/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;

class UserRepository {
  // static Future<UserCredential> appleFlutterWebAuth() async {
  //   final clientState = Uuid().v4();
  //   final url = Uri.https('appleid.apple.com', '/auth/authorize', {
  //     'response_type': 'code id_token',
  //     'client_id': "com.example.coupleToDoListApp.web",
  //     'response_mode': 'form_post',
  //     'redirect_uri':
  //         'https://bottlenose-tungsten-rumba.glitch.me/callbacks/apple/sign_in',
  //     'scope': 'email name',
  //     'state': clientState,
  //   });
  //
  //   final result = await FlutterWebAuth.authenticate(
  //       url: url.toString(), callbackUrlScheme: "applink");
  //
  //   final body = Uri.parse(result).queryParameters;
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: body['id_token'],
  //     accessToken: body['code'],
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
  //
  // static Future<UserCredential> iosSignInWithApple() async {
  //   final appleCredential = await apple.SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       apple.AppleIDAuthorizationScopes.email,
  //       apple.AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     accessToken: appleCredential.authorizationCode,
  //   );
  //   //print(oauthCredential);
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
  //
  // static Future<UserCredential> androidSignInWithApple() async {
  //   final appleCredential = await apple.SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       apple.AppleIDAuthorizationScopes.email,
  //       apple.AppleIDAuthorizationScopes.fullName,
  //     ],
  //     webAuthenticationOptions: apple.WebAuthenticationOptions(
  //       clientId: "com.example.coupleToDoListApp.web",
  //       redirectUri: Uri.parse(
  //           "https://bottlenose-tungsten-rumba.glitch.me/callbacks/sign_in_with_apple"),
  //     ),
  //   );
  //
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     accessToken: appleCredential.authorizationCode,
  //   );
  //   //print(oauthCredential);
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  //구글 로그인
  static Future<UserCredential> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    // final GoogleSignIn googleSignIn = GoogleSignIn(
    //     scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);
    //구글 로그인 페이지 표시
    final google.GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return openAlertDialog(title: '로그인 정보가 없습니다.');
    }
    //로그인 성공, 유저정보 가져오기
    final google.GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    //print('(user repo) idtoken ${googleAuth.idToken}');
    //print('(user repo) accesstoken ${googleAuth.accessToken}');
    //파이어베이스 인증 정보 로그인
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('(user repo) credential $credential');
    return await auth.signInWithCredential(credential);
  }

  //페이스북 로그인
  static Future<UserCredential> signInWithFacebook() async {
    print('로그인 시작');
    final facebook.LoginResult result =
        await facebook.FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    if (result.status == facebook.LoginStatus.success) {
      print('로그인 완료');
      final facebook.AccessToken accessToken = result.accessToken!;
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } else {
      print('로그인 실패');
      return openAlertDialog(title: '유저 정보가 없습니다.');
    }
  }

  static Future<UserModel?> getUserData(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();
    // print('유저 로그인 완료');
    if (data.size == 0) {
      print('데이터 없음');
      return null;
    } else {
      //데이터 있음
      print(data.docs.first.data());
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  Future<void> updateUserModel(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toJson());
    } catch (e) {
      openAlertDialog(title: '오류 발생', content: e.toString());
    }
  }

  static Future<void> signup(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      openAlertDialog(title: '회원가입에 실패했습니다', content: e.toString());
    }
  }

  static Future<void> removeRoomId(String uid, String roomIdToRemove) async {
    UserModel? userModel = await getUserData(uid);
    if (userModel != null) {
      List<String> updatedRoomIdList = List<String>.from(userModel.roomIdList!);
      updatedRoomIdList.remove(roomIdToRemove);
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uid)
            .update({'roomIdList': updatedRoomIdList});
      } catch (e) {
        // 업데이트 중 오류 발생 처리
        print('Error updating user data: $e');
      }
    } else {
      openAlertDialog(title: '유저 정보가 없습니다.');
    }
  }


  static Future signOut() async {
    try {
      if (AuthController.to.user.value.loginType == 'google') {
        //이전 로그인 기록 지우기
        //todo: 해보니까 이전 로그인 기록 지워지지 않은것 같은데 그럼 왜 await googleSignIn.signOut();가 필요한거지?일단 앱 돌아가는데 아무 문제 없으니 스킵.
        try {
    final google.GoogleSignIn googleSignIn = google.GoogleSignIn();
          await googleSignIn.signOut();

        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      }
      // if (AuthController.to.user.value.loginType == 'facebook') {
      //   //이전 로그인 기록 지우기
      //   try {
      //     await facebook.signOut();
      //
      //   } catch (e) {
      //     openAlertDialog(title: e.toString());
      //   }
      // }
      if (AuthController.to.user.value.loginType == 'apple') {
        try {
          //apple 은 굳이 unlink 할 필요 없을듯?
        } catch (e) {
          openAlertDialog(title: e.toString());
        }
      }
      await FirebaseAuth.instance.signOut();
      print('await FirebaseAuth.instance.signOut();');
      // AuthController.to.clearAuthController();
      print(
          "로그아웃 성공! AuthController.to.user.value.email = ${AuthController.to.user.value.email}");
    } catch (e) {
      print('로그아웃 실패${e.toString()}');
    }

  }

}
