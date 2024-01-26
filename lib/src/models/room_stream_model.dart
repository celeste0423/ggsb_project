class RoomStreamModel {
  final String? uid;
  final String? roomId;
  final String? nickname;
  final int? totalSeconds;
  final int? totalLiveSeconds;
  final bool? isTimer;
  final DateTime? startTime;
  final DateTime? lastTime;

  RoomStreamModel({
    this.uid,
    this.roomId,
    this.nickname,
    this.totalSeconds,
    this.totalLiveSeconds,
    this.isTimer,
    this.startTime,
    this.lastTime,
  });

  factory RoomStreamModel.fromJson(Map<String, dynamic> json) {
    return RoomStreamModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      roomId: json['roomId'] == null ? null : json['roomId'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      totalSeconds:
          json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
      totalLiveSeconds: json['totalLiveSeconds'] == null
          ? null
          : json['totalLiveSeconds'] as int,
      isTimer: json['isTimer'] == null ? null : json['isTimer'] as bool,
      startTime: json['startTime'] == null ? null : json["startTime"].toDate(),
      lastTime: json['lastTime'] == null ? null : json["lastTime"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'roomId': roomId,
      'nickname': nickname,
      'totalSeconds': totalSeconds,
      'totalLiveSeconds': totalLiveSeconds,
      'isTimer': isTimer,
      'startTime': startTime,
      'lastTime': lastTime,
    };
  }

  RoomStreamModel copyWith({
    String? uid,
    String? roomId,
    String? nickname,
    int? totalSeconds,
    int? totalLiveSeconds,
    bool? isTimer,
    DateTime? startTime,
    DateTime? lastTime,
  }) {
    return RoomStreamModel(
      uid: uid ?? this.uid,
      roomId: roomId ?? this.roomId,
      nickname: nickname ?? this.nickname,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      totalLiveSeconds: totalLiveSeconds ?? this.totalLiveSeconds,
      isTimer: isTimer ?? this.isTimer,
      startTime: startTime ?? this.startTime,
      lastTime: lastTime ?? this.lastTime,
    );
  }
}
