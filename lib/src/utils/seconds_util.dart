class SecondsUtil {
  static String convertToDigitString(int totalSeconds) {
    int hour = totalSeconds ~/ 3600;
    int minute = (totalSeconds % 3600) ~/ 60;
    int second = (totalSeconds % 60).toInt();
    return '${digits(hour)}:${digits(minute)}:${digits(second)}';
  }

  static int convertToHours(int totalSeconds) {
    return totalSeconds ~/ 3600;
  }

  static int convertToMinutes(int totalSeconds) {
    return (totalSeconds % 3600) ~/ 60;
  }

  static int convertToSeconds(int totalSeconds) {
    return (totalSeconds % 60).toInt();
  }

  //00:00:00 형식으로 만들어줌
  static String digits(int number) {
    return number.toString().padLeft(2, '0');
  }

  static int calculateDifferenceInSeconds(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inSeconds;
  }

  static int convertToTotalMinutes(int totalSeconds){
    return totalSeconds~/60;
  }
}
