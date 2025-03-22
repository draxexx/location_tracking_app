import 'package:intl/intl.dart';

extension DurationExtensions on DateTime {
  String formatDate() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(this);

    return formattedDate;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
