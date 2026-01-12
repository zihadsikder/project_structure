import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLoggerHelper {
  AppLoggerHelper._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.off,
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  static void verbose(String message) {
    _logger.t(message);
  }

  static void critical(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.f(
      message,
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
}
