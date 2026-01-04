import 'dart:developer' as developer;

/// Logging levels
enum LogLevel { debug, info, warning, error, fatal }

/// Application logger with different log levels and formatting
class AppLogger {
  static const String _name = 'CloveScheduler';
  static LogLevel _minLevel = LogLevel.debug;

  /// Sets the minimum log level
  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  /// Logs a debug message
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal error message
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
  }

  /// Internal logging method
  static void _log(LogLevel level, String message, {Object? error, StackTrace? stackTrace}) {
    if (level.index < _minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.toUpperCase().padRight(7);
    final formattedMessage = '[$timestamp] $levelName: $message';

    // Use developer.log for better integration with Flutter DevTools
    developer.log(formattedMessage, name: _name, level: _getLevelValue(level), error: error, stackTrace: stackTrace);
  }

  /// Converts LogLevel to int value for developer.log
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }
}

/// Logger mixin for classes that need logging capabilities
mixin LoggerMixin {
  /// Gets the logger name based on the class name
  String get loggerName => runtimeType.toString();

  /// Logs a debug message with class context
  void logDebug(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.debug('[$loggerName] $message', error: error, stackTrace: stackTrace);
  }

  /// Logs an info message with class context
  void logInfo(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.info('[$loggerName] $message', error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message with class context
  void logWarning(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.warning('[$loggerName] $message', error: error, stackTrace: stackTrace);
  }

  /// Logs an error message with class context
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.error('[$loggerName] $message', error: error, stackTrace: stackTrace);
  }

  /// Logs a fatal error message with class context
  void logFatal(String message, {Object? error, StackTrace? stackTrace}) {
    AppLogger.fatal('[$loggerName] $message', error: error, stackTrace: stackTrace);
  }
}

/// Performance logging utilities
class PerformanceLogger {
  static final Map<String, DateTime> _startTimes = {};

  /// Starts timing an operation
  static void startTimer(String operationName) {
    _startTimes[operationName] = DateTime.now();
    AppLogger.debug('Started timing: $operationName');
  }

  /// Ends timing an operation and logs the duration
  static void endTimer(String operationName) {
    final startTime = _startTimes.remove(operationName);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.info('Operation "$operationName" completed in ${duration.inMilliseconds}ms');
    } else {
      AppLogger.warning('No start time found for operation: $operationName');
    }
  }

  /// Times a synchronous operation
  static T timeSync<T>(String operationName, T Function() operation) {
    startTimer(operationName);
    try {
      final result = operation();
      endTimer(operationName);
      return result;
    } catch (e) {
      endTimer(operationName);
      AppLogger.error('Operation "$operationName" failed', error: e);
      rethrow;
    }
  }

  /// Times an asynchronous operation
  static Future<T> timeAsync<T>(String operationName, Future<T> Function() operation) async {
    startTimer(operationName);
    try {
      final result = await operation();
      endTimer(operationName);
      return result;
    } catch (e) {
      endTimer(operationName);
      AppLogger.error('Operation "$operationName" failed', error: e);
      rethrow;
    }
  }
}

/// Network request logging utilities
class NetworkLogger {
  /// Logs an HTTP request
  static void logRequest(String method, String url, {Map<String, dynamic>? headers, Object? body}) {
    AppLogger.info('HTTP $method $url');
    if (headers != null && headers.isNotEmpty) {
      AppLogger.debug('Request headers: $headers');
    }
    if (body != null) {
      AppLogger.debug('Request body: $body');
    }
  }

  /// Logs an HTTP response
  static void logResponse(String method, String url, int statusCode, {Object? body, Duration? duration}) {
    final durationText = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    AppLogger.info('HTTP $method $url -> $statusCode$durationText');
    if (body != null) {
      AppLogger.debug('Response body: $body');
    }
  }

  /// Logs an HTTP error
  static void logError(String method, String url, Object error, {StackTrace? stackTrace}) {
    AppLogger.error('HTTP $method $url failed', error: error, stackTrace: stackTrace);
  }
}

/// Database operation logging utilities
class DatabaseLogger {
  /// Logs a database query
  static void logQuery(String query, {List<Object?>? parameters}) {
    AppLogger.debug('DB Query: $query');
    if (parameters != null && parameters.isNotEmpty) {
      AppLogger.debug('DB Parameters: $parameters');
    }
  }

  /// Logs a database operation result
  static void logResult(String operation, int affectedRows, {Duration? duration}) {
    final durationText = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    AppLogger.debug('DB $operation: $affectedRows rows affected$durationText');
  }

  /// Logs a database error
  static void logError(String operation, Object error, {StackTrace? stackTrace}) {
    AppLogger.error('DB $operation failed', error: error, stackTrace: stackTrace);
  }
}
