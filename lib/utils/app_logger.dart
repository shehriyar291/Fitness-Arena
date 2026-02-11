/// Centralized logging utility for the application
class AppLogger {
  /// Log debug information
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('DEBUG', message, error, stackTrace);
  }

  /// Log info level
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('INFO', message, error, stackTrace);
  }

  /// Log warning
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('WARNING', message, error, stackTrace);
  }

  /// Log error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }

  /// Log fatal/critical error
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('FATAL', message, error, stackTrace);
  }

  /// Log database operations
  static void database(String operation, {String? details}) {
    _log('DATABASE', operation, details, null);
  }

  /// Log authentication operations
  static void auth(String operation, {String? details}) {
    _log('AUTH', operation, details, null);
  }

  /// Log UI operations
  static void ui(String operation, {String? details}) {
    _log('UI', operation, details, null);
  }

  /// Internal logging method
  static void _log(
    String level,
    String message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final timestamp = DateTime.now().toIso8601String();
    final errorMsg = error != null ? ' | Error: $error' : '';
    final stackMsg = stackTrace != null ? '\nStackTrace: $stackTrace' : '';
    print('[$timestamp] $level: $message$errorMsg$stackMsg');
  }
}
