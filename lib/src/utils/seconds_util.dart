class SecondsUtil {
  static String convertToDigitString(int totalSeconds) {
    int hour = (totalSeconds / 3600).toInt();
    int minute = ((totalSeconds % 3600) / 60).toInt();
    int second = (totalSeconds % 60).toInt();
    return '${_digits(hour)}:${_digits(minute)}:${_digits(second)}';
  }

  //00:00:00 형식으로 만들어줌
  static String _digits(int number) {
    return number.toString().padLeft(2, '0');
  }

  static int calculateDifferenceInSeconds(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return difference.inSeconds;
  }
}
