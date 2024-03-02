import 'package:intl/intl.dart';

class NumberUtil {
  static String formatNumber(int number) {
    // 숫자를 1000단위로 구분하여 쉼표로 포맷팅
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
