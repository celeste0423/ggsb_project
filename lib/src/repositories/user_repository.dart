import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggsb_project/src/models/user_model.dart';

class UserRepository {
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
