import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(Object message, {bool forceLog: false}) {
    if (forceLog || !kReleaseMode) {
      print(message);
    }
  }
}
