import 'package:ggsb_project/src/models/study_time_model.dart';
import 'package:intl/intl.dart';

class DateUtil {
  // static String getDayOfWeek(DateTime date) {
  //   List<String> daysOfWeek = [
  //     'Monday',
  //     'Tuesday',
  //     'Wednesday',
  //     'Thursday',
  //     'Friday',
  //     'Saturday',
  //     'Sunday'
  //   ];
  //   return daysOfWeek[date.weekday - 1];
  // }

  static DateTime standardRefreshTime(DateTime date) {
    //새벽 4시로 설정함
    return DateTime(date.year, date.month, date.day, 4);
  }

  static String getDayOfWeekBeforeStandartRefreshTime(DateTime date) {
    // 새벽 4시를 나타내는 DateTime 객체 생성
    DateTime fourAM = standardRefreshTime(date);

    // 입력된 DateTime 객체가 새벽 4시 이전인지 확인
    if (date.isBefore(fourAM)) {
      // 새벽 4시 이전이라면 이전 날의 요일을 반환
      DateTime previousDay = date.subtract(Duration(days: 1));
      List<String> daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return daysOfWeek[previousDay.weekday - 1];
    } else {
      // 새벽 4시 이후라면 해당 날짜의 요일을 반환
      List<String> daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return daysOfWeek[date.weekday - 1];
    }
  }

  static String getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return daysOfWeek[date.weekday - 1];
  }

  // static int calculateDateDifference(DateTime startDate, DateTime endDate) {
  //   // 날짜 차이 계산
  //   Duration difference = endDate.difference(startDate);
  //   // 일 수로 변환하여 반환
  //   return difference.inDays;
  // }
  int calculateDateDifference(DateTime startDate, DateTime endDate) {
    // 시작일이 오늘 새벽 4시 이전이고 종료일이 오늘 새벽 4시 이후인 경우
    if (startDate.isBefore(standardRefreshTime(startDate)) &&
        endDate.isAfter(standardRefreshTime(endDate))) {
      // 시작일을 하루 전으로 설정
      startDate = startDate.subtract(Duration(days: 1));
    }
    // 날짜 차이 계산
    int difference = daysBetween(startDate, endDate);
    // print('차이 ${difference}');
    // 일 수로 변환하여 반환
    return difference;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  String getDayTo(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  int getDayOfWeekIndex(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 0; // 기본값으로 0을 반환하거나 예외 처리를 수행할 수 있습니다.
    }
  }

  // List<TimeModel> sortByDay(List<TimeModel> timeModelList) {
  //   timeModelList.sort((a, b) {
  //     int dayA = getDayOfWeekIndex(a.day!);
  //     int dayB = getDayOfWeekIndex(b.day!);
  //     //반환값이 양수인 경우 a와 b의 위치를 바꿈(더 크니까)
  //     return dayA - dayB;
  //   });
  //   return timeModelList;
  // }

  List<StudyTimeModel> sortByDateString(
      List<StudyTimeModel> studyTimeModelList) {
    studyTimeModelList.sort((a, b) {
      // 날짜 문자열을 DateTime 객체로 변환
      DateTime dateA = stringToDateTime(a.date!);
      DateTime dateB = stringToDateTime(b.date!);
      // DateTime을 비교하여 최신 순서로 정렬
      return dateA.compareTo(dateB);
    });
    for (StudyTimeModel studyTimeModel in studyTimeModelList) {
      print('스터디모델 순서정렬 ${studyTimeModel.date}');
    }
    return studyTimeModelList;
  }

  String dateTimeToString(DateTime dateTime) {
    // dateTime이 standardRefreshTime 이전인지 확인
    if (dateTime.isBefore(standardRefreshTime(dateTime))) {
      // 이전이면 전날로 설정
      dateTime = dateTime.subtract(Duration(days: 1));
    }

    // 날짜를 문자열로 변환하여 반환
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime stringToDateTime(String dateString) {
    DateFormat format = DateFormat('yyyy-MM-dd');
    return format.parse(dateString);
  }

  DateTime getYesterday() {
    return DateTime.now().subtract(Duration(days: 1));
  }
}
