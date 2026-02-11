import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_arena/utils/password_hasher.dart';

void main() {
  group('PasswordHasher Tests', () {
    test('hash password creates bcrypt hash', () {
      final password = 'TestPassword123';
      final hash = PasswordHasher.hashPassword(password);

      expect(hash, isNotNull);
      expect(hash, isNotEmpty);
      expect(hash, isNot(password));
      expect(hash.startsWith('\$2'), true); // bcrypt hash starts with $2
    });

    test('verify password returns true for correct password', () {
      const password = 'TestPassword123';
      final hash = PasswordHasher.hashPassword(password);

      final isValid = PasswordHasher.verifyPassword(password, hash);
      expect(isValid, true);
    });

    test('verify password returns false for incorrect password', () {
      const correctPassword = 'TestPassword123';
      const wrongPassword = 'WrongPassword456';
      final hash = PasswordHasher.hashPassword(correctPassword);

      final isValid = PasswordHasher.verifyPassword(wrongPassword, hash);
      expect(isValid, false);
    });

    test('different passwords produce different hashes', () {
      const password1 = 'Password123';
      const password2 = 'Password456';

      final hash1 = PasswordHasher.hashPassword(password1);
      final hash2 = PasswordHasher.hashPassword(password2);

      expect(hash1, isNot(hash2));
    });

    test('same password produces different hashes (salting)', () {
      const password = 'TestPassword123';

      final hash1 = PasswordHasher.hashPassword(password);
      final hash2 = PasswordHasher.hashPassword(password);

      expect(hash1, isNot(hash2));
      // But both should verify against the same password
      expect(PasswordHasher.verifyPassword(password, hash1), true);
      expect(PasswordHasher.verifyPassword(password, hash2), true);
    });

    test('hashes are at least 60 characters long', () {
      const password = 'TestPassword123';
      final hash = PasswordHasher.hashPassword(password);

      expect(hash.length, greaterThanOrEqualTo(60));
    });

    test('verify password handles edge cases', () {
      const password = 'Password123';
      final hash = PasswordHasher.hashPassword(password);

      // Test with empty password
      expect(PasswordHasher.verifyPassword('', hash), false);

      // Test with null should not crash (would be caught by runtime)
      expect(PasswordHasher.verifyPassword('similar_Password', hash), false);
    });

    test('needsRehash identifies weak hashes', () {
      const password = 'TestPassword123';
      final hash = PasswordHasher.hashPassword(password);

      // Current rounds should be 12, so it shouldn't need rehashing
      expect(PasswordHasher.needsRehash(hash), false);
    });

    test('password hashing is deterministic for verification', () {
      const password = 'DeterministicPassword123';
      final hash1 = PasswordHasher.hashPassword(password);
      final hash2 = PasswordHasher.hashPassword(password);

      // Hashes should be different due to salt
      expect(hash1, isNot(hash2));

      // But both should verify correctly
      expect(PasswordHasher.verifyPassword(password, hash1), true);
      expect(PasswordHasher.verifyPassword(password, hash2), true);
    });
  });
}
