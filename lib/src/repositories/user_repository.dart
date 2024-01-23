import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static Future<UserModel?> loginUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      print('데이터 없음');
      return null;
    } else {
      //데이터 있음
      // print(data.docs.first.data());
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  static Future<bool> signup(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
