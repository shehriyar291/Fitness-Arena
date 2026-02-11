import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_arena/constants/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    test('color constants are valid', () {
      expect(AppConstants.primaryColorValue, isNotNull);
      expect(AppConstants.secondaryColorValue, isNotNull);
      expect(AppConstants.errorColorValue, isNotNull);
    });

    test('database constant names are defined', () {
      expect(AppConstants.gymMembersBoxName, 'gym_members');
      expect(AppConstants.gymAdminsBoxName, 'gym_admins');
      expect(AppConstants.authTokenKey, 'current_admin');
    });

    test('validation constraints are reasonable', () {
      expect(AppConstants.minPasswordLength, greaterThan(0));
      expect(
        AppConstants.maxPasswordLength,
        greaterThan(AppConstants.minPasswordLength),
      );
      expect(AppConstants.minNameLength, greaterThan(0));
      expect(
        AppConstants.maxNameLength,
        greaterThan(AppConstants.minNameLength),
      );
    });

    test('member types list is not empty', () {
      expect(AppConstants.memberTypes, isNotEmpty);
      expect(AppConstants.memberTypes, contains('Basic'));
      expect(AppConstants.memberTypes, contains('Premium'));
      expect(AppConstants.memberTypes, contains('VIP'));
    });

    test('months list has 12 entries', () {
      expect(AppConstants.months, hasLength(12));
    });

    test('payment methods list is not empty', () {
      expect(AppConstants.paymentMethods, isNotEmpty);
      expect(AppConstants.paymentMethods, contains('Cash'));
    });

    test('error messages are non-empty strings', () {
      expect(AppConstants.unknownError, isNotEmpty);
      expect(AppConstants.databaseError, isNotEmpty);
      expect(AppConstants.authenticationError, isNotEmpty);
      expect(AppConstants.validationError, isNotEmpty);
      expect(AppConstants.operationFailed, isNotEmpty);
    });

    test('success messages are non-empty strings', () {
      expect(AppConstants.memberAdded, isNotEmpty);
      expect(AppConstants.memberUpdated, isNotEmpty);
      expect(AppConstants.memberDeleted, isNotEmpty);
      expect(AppConstants.signupSuccess, isNotEmpty);
      expect(AppConstants.loginSuccess, isNotEmpty);
    });
  });
}
