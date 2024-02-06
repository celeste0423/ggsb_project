// class TimeModel {
//   final String? uid;
//   final String? day;
//   final int? totalSeconds;
//   final bool? isTimer;
//   final DateTime? startTime;
//   final DateTime? lastTime;
//
//   TimeModel({
//     this.uid,
//     this.day,
//     this.totalSeconds,
//     this.isTimer,
//     this.startTime,
//     this.lastTime,
//   });
//
//   factory TimeModel.fromJson(Map<String, dynamic> json) {
//     return TimeModel(
//       uid: json['uid'] == null ? null : json['uid'] as String,
//       day: json['day'] == null ? null : json['day'] as String,
//       totalSeconds:
//           json['totalSeconds'] == null ? null : json['totalSeconds'] as int,
//       isTimer: json['isTimer'] == null ? null : json['isTimer'] as bool,
//       startTime: json['startTime'] == null ? null : json["startTime"].toDate(),
//       lastTime: json['lastTime'] == null ? null : json["lastTime"].toDate(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'day': day,
//       'totalSeconds': totalSeconds,
//       'isTimer': isTimer,
//       'startTime': startTime,
//       'lastTime': lastTime,
//     };
//   }
//
//   TimeModel copyWith({
//     String? uid,
//     String? day,
//     int? totalSeconds,
//     int? totalLiveSeconds,
//     bool? isTimer,
//     DateTime? startTime,
//     DateTime? lastTime,
//   }) {
//     return TimeModel(
//       uid: uid ?? this.uid,
//       day: day ?? this.day,
//       totalSeconds: totalSeconds ?? this.totalSeconds,
//       isTimer: isTimer ?? this.isTimer,
//       startTime: startTime ?? this.startTime,
//       lastTime: lastTime ?? this.lastTime,
//     );
//   }
// }
