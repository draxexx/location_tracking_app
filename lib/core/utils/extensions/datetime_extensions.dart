import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  /// Formats the date to a human readable string.
  String formatDate() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(this);

    return formattedDate;
  }

  /// Checks if the date is the same as the other date.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
