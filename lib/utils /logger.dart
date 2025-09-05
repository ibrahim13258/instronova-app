import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  // Singleton
  AppLogger._privateConstructor();
  static final AppLogger instance = AppLogger._privateConstructor();

  bool isDebugMode = kDebugMode; // Only print in debug mode

  void log(String message,
      {LogLevel level = LogLevel.debug, String? tag, dynamic error, StackTrace? stackTrace}) {
    if (!isDebugMode) return;

    final logTag = tag != null ? '[$tag]' : '';
    final logMessage = '$logTag $message';

    switch (level) {
      case LogLevel.debug:
        developer.log(logMessage, name: 'DEBUG', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.info:
        developer.log(logMessage, name: 'INFO', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.warning:
        developer.log(logMessage, name: 'WARNING', error: error, stackTrace: stackTrace);
        break;
      case LogLevel.error:
        developer.log(logMessage, name: 'ERROR', error: error, stackTrace: stackTrace);
        break;
    }
  }

  // Shortcut methods
  void d(String message, {String? tag}) => log(message, level: LogLevel.debug, tag: tag);
  void i(String message, {String? tag}) => log(message, level: LogLevel.info, tag: tag);
  void w(String message, {String? tag}) => log(message, level: LogLevel.warning, tag: tag);
  void e(String message, {String? tag, dynamic error, StackTrace? stackTrace}) =>
      log(message, level: LogLevel.error, tag: tag, error: error, stackTrace: stackTrace);
}
