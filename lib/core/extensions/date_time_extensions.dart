import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  static DateTime firstDayOfYear() {
    final now = DateTime.now();

    return DateTime(now.year, 1, 1, 0, 0, 0);
  }

  static DateTime lastDayOfYear() {
    final now = DateTime.now();

    return DateTime(now.year, 12, 31, 23, 59, 59);
  }

  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
