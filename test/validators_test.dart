import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_arena/constants/app_constants.dart';
import 'package:fitness_arena/constants/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateName', () {
      test('returns error for empty name', () {
        expect(Validators.validateName(''), isNotNull);
        expect(Validators.validateName(null), isNotNull);
      });

      test('returns error for name shorter than minimum length', () {
        expect(Validators.validateName('A'), isNotNull);
      });

      test('returns error for name longer than maximum length', () {
        expect(
          Validators.validateName('A' * (AppConstants.maxNameLength + 1)),
          isNotNull,
        );
      });

      test('returns error for name with invalid characters', () {
        expect(Validators.validateName('John123'), isNotNull);
        expect(Validators.validateName('John@Doe'), isNotNull);
      });

      test('returns null for valid names', () {
        expect(Validators.validateName('John Doe'), isNull);
        expect(Validators.validateName('Mary-Jane'), isNull);
        expect(Validators.validateName('O\'Brien'), isNull);
      });
    });

    group('validatePassword', () {
      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('returns error for password shorter than minimum length', () {
        expect(Validators.validatePassword('Abc12'), isNotNull);
      });

      test('returns error for password without uppercase', () {
        expect(Validators.validatePassword('abcdef123'), isNotNull);
      });

      test('returns error for password without lowercase', () {
        expect(Validators.validatePassword('ABCDEF123'), isNotNull);
      });

      test('returns error for password without digit', () {
        expect(Validators.validatePassword('AbcdefGhi'), isNotNull);
      });

      test('returns null for valid password', () {
        expect(Validators.validatePassword('Password123'), isNull);
        expect(Validators.validatePassword('MySecure1'), isNull);
      });
    });

    group('validatePasswordMatch', () {
      test('returns error for empty confirm password', () {
        expect(Validators.validatePasswordMatch('Password123', ''), isNotNull);
        expect(
          Validators.validatePasswordMatch('Password123', null),
          isNotNull,
        );
      });

      test('returns error for non-matching passwords', () {
        expect(
          Validators.validatePasswordMatch('Password123', 'DifferentPass1'),
          isNotNull,
        );
      });

      test('returns null for matching passwords', () {
        expect(
          Validators.validatePasswordMatch('Password123', 'Password123'),
          isNull,
        );
      });
    });

    group('validatePhone', () {
      test('returns error for empty phone', () {
        expect(Validators.validatePhone(''), isNotNull);
        expect(Validators.validatePhone(null), isNotNull);
      });

      test('returns error for phone with invalid characters', () {
        expect(Validators.validatePhone('123abc456'), isNotNull);
      });

      test('returns error for phone with less than 10 digits', () {
        expect(Validators.validatePhone('12345'), isNotNull);
      });

      test('returns null for valid phone numbers', () {
        expect(Validators.validatePhone('9876543210'), isNull);
        expect(Validators.validatePhone('+91 98765 43210'), isNull);
        expect(Validators.validatePhone('(987) 654-3210'), isNull);
      });
    });

    group('validateEmail', () {
      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('returns error for invalid email format', () {
        expect(Validators.validateEmail('invalid'), isNotNull);
        expect(Validators.validateEmail('invalid@'), isNotNull);
        expect(Validators.validateEmail('@invalid.com'), isNotNull);
      });

      test('returns null for valid emails', () {
        expect(Validators.validateEmail('user@example.com'), isNull);
        expect(Validators.validateEmail('test.email+tag@domain.co.uk'), isNull);
      });
    });

    group('validateAmount', () {
      test('returns error for empty amount', () {
        expect(Validators.validateAmount(''), isNotNull);
        expect(Validators.validateAmount(null), isNotNull);
      });

      test('returns error for non-numeric amount', () {
        expect(Validators.validateAmount('abc'), isNotNull);
      });

      test('returns error for zero or negative amount', () {
        expect(Validators.validateAmount('0'), isNotNull);
        expect(Validators.validateAmount('-100'), isNotNull);
      });

      test('returns null for valid amounts', () {
        expect(Validators.validateAmount('100'), isNull);
        expect(Validators.validateAmount('100.50'), isNull);
      });
    });

    group('validateAddress', () {
      test('returns error for empty address', () {
        expect(Validators.validateAddress(''), isNotNull);
        expect(Validators.validateAddress(null), isNotNull);
      });

      test('returns error for address shorter than 5 characters', () {
        expect(Validators.validateAddress('123'), isNotNull);
      });

      test('returns null for valid address', () {
        expect(Validators.validateAddress('123 Main Street'), isNull);
        expect(Validators.validateAddress('Apartment 4B'), isNull);
      });
    });

    group('validateRequired', () {
      test('returns error for empty value', () {
        expect(Validators.validateRequired(''), isNotNull);
        expect(Validators.validateRequired(null), isNotNull);
      });

      test('returns null for non-empty value', () {
        expect(Validators.validateRequired('some value'), isNull);
      });

      test('includes field name in error message', () {
        final result = Validators.validateRequired(
          '',
          fieldName: 'Custom Field',
        );
        expect(result, contains('Custom Field'));
      });
    });
  });
}
