class StudyTimeModel {
  final String? uid;
  final String? date;
  final int? totalSeconds;
  final DateTime? startTime;
  final DateTime? lastTime;

  StudyTimeModel({
    this.uid,
    this.date,
    this.totalSeconds,
    this.startTime,
    this.lastTime,
  });

  factory StudyTimeModel.fromJson(Map<String, dynamic> json) {
    return StudyTimeModel(
      uid: json['uid'] == null ? null : json['uid'] as String,
      date: json['date'] == null ? null : json['date'] as String,
      totalSeconds:
          json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
      startTime: json['startTime'] == null ? null : json["startTime"].toDate(),
      lastTime: json['lastTime'] == null ? null : json["lastTime"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'totalSeconds': totalSeconds,
      'startTime': startTime,
      'lastTime': lastTime,
    };
  }

  StudyTimeModel copyWith({
    String? uid,
    String? date,
    int? totalSeconds,
    int? totalLiveSeconds,
    DateTime? startTime,
    DateTime? lastTime,
  }) {
    return StudyTimeModel(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      startTime: startTime ?? this.startTime,
      lastTime: lastTime ?? this.lastTime,
    );
  }
}
