import 'package:intl/intl.dart';

class NumberUtil {
  static String formatNumber(int number) {
    // 숫자를 1000단위로 구분하여 쉼표로 포맷팅
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  static String toOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' 'th';
    }
    switch (number % 10) {
      case 1:
        return '$number' 'st';
      case 2:
        return '$number' 'nd';
      case 3:
        return '$number' 'rd';
      default:
        return '$number' 'th';
    }
  }
}
