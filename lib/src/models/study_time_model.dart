class StudyTimeModel {
  final String? uid;
  final String? nickname;
  final String? date;
  final DateTime? createdAt;
  final int? totalSeconds;
  final DateTime? startTime;
  final DateTime? lastTime;
  final bool? isCashed;

  StudyTimeModel({
    this.uid,
    this.nickname,
    this.date,
    this.createdAt,
    this.totalSeconds,
    this.startTime,
    this.lastTime,
    this.isCashed,
  });

  factory StudyTimeModel.fromJson(Map<String, dynamic> json) {
    return StudyTimeModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      nickname: json['nickname'] == null ? null : json['nickname'] as String,
      date: json['date'] == null ? null : json['date'] as String,
      createdAt:
          json['createdAt'] == null ? null : json['createdAt'] as DateTime,
      totalSeconds:
          json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
      startTime: json['startTime'] == null ? null : json["startTime"].toDate(),
      lastTime: json['lastTime'] == null ? null : json["lastTime"].toDate(),
      isCashed: json['isCashed'] == null ? null : json['isCashed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'date': date,
      'createdAt': createdAt,
      'totalSeconds': totalSeconds,
      'startTime': startTime,
      'lastTime': lastTime,
      'isCashed': isCashed,
    };
  }

  StudyTimeModel copyWith({
    String? uid,
    String? nickname,
    String? date,
    DateTime? createdAt,
    int? totalSeconds,
    int? totalLiveSeconds,
    DateTime? startTime,
    DateTime? lastTime,
    bool? isCashed,
  }) {
    return StudyTimeModel(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      startTime: startTime ?? this.startTime,
      lastTime: lastTime ?? this.lastTime,
      isCashed: isCashed ?? this.isCashed,
    );
  }
}
