import 'dart:ffi';

import 'package:ggsb_project/src/constants/login_type_enum.dart';

class UserModel {
  final String? uid;
  final String? nickname;
  final LoginType? loginType;
  final String? email;
  final String? gender;
  final String? school;
  final bool? isTimer;
  final int? totalSeconds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.uid,
    this.nickname,
    this.loginType,
    this.email,
    this.gender,
    this.school,
    this.isTimer,
    this.totalSeconds,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      loginType: json['loginType'] == null
          ? null
          : LoginTypeExtension.fromString(json['loginType'] as String),
      email: json['email'] == null ? null : json['email'] as String,
      gender: json['gender'] == null ? null : json['gender'] as String,
      school: json['school'] == null ? null : json['school'] as String,
      isTimer: json['isTimer'] == null ? null : json['isTimer'] as bool,
      totalSeconds:
          json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
      createdAt: json['createdAt'] == null ? null : json['createdAt'].toDate(),
      updatedAt: json['updatedAt'] == null ? null : json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'loginType': loginType,
      'email': email,
      'gender': gender,
      'school': school,
      'isTimer': isTimer,
      'totalSeconds': totalSeconds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? uid,
    String? nickname,
    LoginType? loginType,
    String? email,
    String? gender,
    String? school,
    bool? isTimer,
    int? totalSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      loginType: loginType ?? this.loginType,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      isTimer: isTimer ?? this.isTimer,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      school: school ?? this.school,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.createdAt,
    );
  }
}
