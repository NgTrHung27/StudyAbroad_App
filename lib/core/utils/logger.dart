import 'dart:developer' as developer;

/// Simple logging utility
class AppLogger {
  static const String _tag = 'StudyAbroad';

  static void debug(String message, [Object? data]) {
    _log('DEBUG', message, data);
  }

  static void info(String message, [Object? data]) {
    _log('INFO', message, data);
  }

  static void warning(String message, [Object? data]) {
    _log('WARNING', message, data);
  }

  static void error(String message, [Object? data]) {
    _log('ERROR', message, data);
  }

  static void _log(String level, String message, Object? data) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$_tag][$level][$timestamp] $message';
    
    if (data != null) {
      developer.log('$logMessage\nData: $data');
    } else {
      developer.log(logMessage);
    }
  }
}
