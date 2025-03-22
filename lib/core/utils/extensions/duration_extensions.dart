extension DurationExtensions on Duration {
  /// Formats the duration to a human readable string.
  /// The format is `hours`h `minutes`m `seconds`s.
  String formatDuration() {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    if (hours > 0 && minutes > 0 && seconds > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (hours > 0 && minutes > 0) {
      return "${hours}h ${minutes}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else if (minutes > 0 && seconds > 0) {
      return "${minutes}m ${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m";
    } else {
      return "${seconds}s";
    }
  }
}
