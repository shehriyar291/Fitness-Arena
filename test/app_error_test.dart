import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_arena/models/app_error.dart';

void main() {
  group('AppError Tests', () {
    test('creates error with message', () {
      final error = AppError(message: 'Test error');
      expect(error.message, 'Test error');
      expect(error.code, isNull);
    });

    test('creates error with code and message', () {
      final error = AppError(message: 'Test error', code: 'TEST_CODE');
      expect(error.message, 'Test error');
      expect(error.code, 'TEST_CODE');
    });

    test('database error factory', () {
      final error = AppError.database('DB failed');
      expect(error.message, contains('DB failed'));
      expect(error.isDatabaseError, true);
      expect(error.isAuthError, false);
    });

    test('authentication error factory', () {
      final error = AppError.authentication('Auth failed');
      expect(error.message, contains('Auth failed'));
      expect(error.isAuthError, true);
      expect(error.isDatabaseError, false);
    });

    test('validation error factory', () {
      final error = AppError.validation('Invalid input');
      expect(error.message, contains('Invalid input'));
      expect(error.isValidationError, true);
    });

    test('unknown error factory', () {
      final exception = Exception('Unknown');
      final error = AppError.unknown(exception);
      expect(error.originalException, exception);
      expect(error.code, 'UNKNOWN_ERROR');
    });

    test('network error factory', () {
      final error = AppError.network('Connection failed');
      expect(error.isNetworkError, true);
    });

    test('not found error factory', () {
      final error = AppError.notFound('Item not found');
      expect(error.isNotFound, true);
    });

    test('toString returns message', () {
      final error = AppError(message: 'Test message');
      expect(error.toString(), 'Test message');
    });

    test('error type checks work correctly', () {
      final error = AppError.authentication('Auth error');
      expect(error.isAuthError, true);
      expect(error.isDatabaseError, false);
      expect(error.isValidationError, false);
      expect(error.isNetworkError, false);
      expect(error.isNotFound, false);
    });
  });
}
