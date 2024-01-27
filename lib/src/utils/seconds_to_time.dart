class SecondsToTime {
  static String convert(int totalSeconds) {
    int hour = (totalSeconds / 3600).toInt();
    int minute = ((totalSeconds % 3600) / 60).toInt();
    int second = (totalSeconds % 60).toInt();
    return '${_digits(hour)}:${_digits(minute)}:${_digits(second)}';
  }

  static String _digits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
