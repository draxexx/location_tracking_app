import 'package:flutter/foundation.dart';

/// This class is used to log messages
final class LogHelper {
  /// This method is used to log an info message
  static void info(String message) {
    if (kDebugMode) {
      print("⚠️ $message");
    }
  }
}
