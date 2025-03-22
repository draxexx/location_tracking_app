extension DurationExtensions on Duration {
  /// Formats the duration to a human readable string.
  /// The format is `hours`h `minutes`m.
  String formatDuration() {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return "${hours}h ${minutes}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else {
      return "${minutes}m";
    }
  }
}
