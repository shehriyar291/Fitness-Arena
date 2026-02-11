/// Custom error class for application-wide error handling
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => message;

  /// Factory constructors for common error types
  factory AppError.database(String message) {
    return AppError(message: message, code: 'DATABASE_ERROR');
  }

  factory AppError.authentication(String message) {
    return AppError(message: message, code: 'AUTH_ERROR');
  }

  factory AppError.validation(String message) {
    return AppError(message: message, code: 'VALIDATION_ERROR');
  }

  factory AppError.unknown(dynamic exception, [StackTrace? stackTrace]) {
    return AppError(
      message: 'An unexpected error occurred',
      code: 'UNKNOWN_ERROR',
      originalException: exception,
      stackTrace: stackTrace,
    );
  }

  factory AppError.network(String message) {
    return AppError(message: message, code: 'NETWORK_ERROR');
  }

  factory AppError.notFound(String message) {
    return AppError(message: message, code: 'NOT_FOUND');
  }

  bool get isDatabaseError => code == 'DATABASE_ERROR';
  bool get isAuthError => code == 'AUTH_ERROR';
  bool get isValidationError => code == 'VALIDATION_ERROR';
  bool get isNetworkError => code == 'NETWORK_ERROR';
  bool get isNotFound => code == 'NOT_FOUND';
}
