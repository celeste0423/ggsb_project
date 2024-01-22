class UserModel {
  final String? uid;
  final String? nickname;
  final String? loginType;
  final String? email;
  final String? gender;

  UserModel({
    this.uid,
    this.nickname,
    this.loginType,
    this.email,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      loginType: json['loginType'] == null ? null : json['loginType'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      gender: json['gender'] == null ? null : json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'loginType': loginType,
      'email': email,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? uid,
    String? nickname,
    String? loginType,
    String? email,
    String? gender,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      loginType: loginType ?? this.loginType,
      email: email ?? this.email,
      gender: gender ?? this.gender,
    );
  }
}
