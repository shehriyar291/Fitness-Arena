import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/app_logger.dart';

/// Utility class for secure password hashing and verification
/// Note: This implementation uses SHA256 for compatibility.
/// For production, replace with bcrypt package when available.
class PasswordHasher {
  static const int _saltLength = 32;

  /// Hash a plain text password using SHA256 with salt
  /// Returns the hashed password string in format: salt$hash
  static String hashPassword(String plainPassword) {
    try {
      // Generate a random salt
      final salt = _generateSalt();
      // Hash password with salt
      final hash = sha256.convert(utf8.encode(salt + plainPassword)).toString();
      AppLogger.debug('Password hashed successfully');
      return '$salt\$$hash';
    } catch (e, stackTrace) {
      AppLogger.error('Failed to hash password', e, stackTrace);
      rethrow;
    }
  }

  /// Verify a plain text password against a hashed password
  /// Returns true if the password matches, false otherwise
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    try {
      final parts = hashedPassword.split('\$');
      if (parts.length != 2) {
        AppLogger.warning('Invalid password hash format');
        return false;
      }

      final salt = parts[0];
      final storedHash = parts[1];
      final computedHash = sha256
          .convert(utf8.encode(salt + plainPassword))
          .toString();

      final isValid = computedHash == storedHash;
      if (!isValid) {
        AppLogger.warning('Password verification failed - invalid password');
      }
      return isValid;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to verify password', e, stackTrace);
      return false;
    }
  }

  /// Check if a password needs to be rehashed
  /// Useful when you want to upgrade hashing strength
  static bool needsRehash(String hashedPassword) {
    try {
      final parts = hashedPassword.split('\$');
      return parts.length != 2;
    } catch (e) {
      AppLogger.warning('Failed to check if password needs rehash', e);
      return true;
    }
  }

  /// Generate a random salt for password hashing
  static String _generateSalt() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = StringBuffer();
    for (int i = 0; i < _saltLength; i++) {
      random.write(chars[DateTime.now().microsecond % chars.length]);
    }
    return random.toString();
  }
}
