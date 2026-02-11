import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/admin.dart';
import '../models/app_error.dart';
import '../utils/app_logger.dart';
import '../utils/password_hasher.dart';

/// Service for authentication and admin management
/// Handles admin signup, login, and profile management with secure password hashing
class AuthService {
  static const String adminBoxName = AppConstants.gymAdminsBoxName;
  static const String authTokenKey = AppConstants.authTokenKey;

  /// Initialize authentication database with admin box
  static Future<void> initAuthDatabase() async {
    try {
      AppLogger.auth('Initializing auth database');
      Hive.registerAdapter(AdminAdapter());

      if (!Hive.isBoxOpen(adminBoxName)) {
        await Hive.openBox<Admin>(adminBoxName);
        AppLogger.auth('Auth database initialized');
      }
    } catch (e, stackTrace) {
      final error = AppError.authentication(
        'Auth database initialization failed: $e',
      );
      AppLogger.error('Auth database initialization error', error, stackTrace);
      rethrow;
    }
  }

  /// Get the admin database box
  static Box<Admin> getAdminBox() {
    try {
      return Hive.box<Admin>(adminBoxName);
    } catch (e, stackTrace) {
      final error = AppError.authentication('Failed to access admin box: $e');
      AppLogger.error('Error getting admin box', error, stackTrace);
      rethrow;
    }
  }

  /// Register a new admin with secure password hashing
  /// Returns (success, message)
  static Future<(bool, String)> signup(String name, String password) async {
    try {
      AppLogger.auth('Attempting signup for: $name');
      final box = getAdminBox();

      // Validate inputs
      if (name.trim().isEmpty) {
        return (false, 'Username cannot be empty');
      }
      if (password.isEmpty) {
        return (false, 'Password cannot be empty');
      }

      // Check if admin with same name already exists
      for (final admin in box.values) {
        if (admin.name.toLowerCase() == name.toLowerCase()) {
          AppLogger.warning('Signup failed: Admin already exists - $name');
          return (false, 'An admin with this username already exists');
        }
      }

      // Hash password securely
      final hashedPassword = PasswordHasher.hashPassword(password);

      final newAdmin = Admin(name: name.trim(), password: hashedPassword);

      await box.add(newAdmin);
      AppLogger.auth('Admin signup successful', details: 'Admin: $name');
      return (true, 'Signup successful');
    } on AppError catch (e) {
      AppLogger.error('Signup error - AppError', e);
      return (false, e.message);
    } catch (e, stackTrace) {
      final error = AppError.authentication('Signup failed: $e');
      AppLogger.error('Signup error', error, stackTrace);
      return (false, error.message);
    }
  }

  /// Authenticate admin with username and password
  /// Returns (success, message)
  static Future<(bool, String)> login(String name, String password) async {
    try {
      AppLogger.auth('Attempting login for: $name');

      if (name.trim().isEmpty || password.isEmpty) {
        return (false, 'Username and password are required');
      }

      final box = getAdminBox();

      for (final admin in box.values) {
        if (admin.name.toLowerCase() == name.toLowerCase()) {
          // Verify password using bcrypt
          if (PasswordHasher.verifyPassword(password, admin.password)) {
            AppLogger.auth('Login successful', details: 'Admin: $name');
            return (true, 'Login successful');
          } else {
            AppLogger.warning('Login failed: Invalid password - $name');
            return (false, 'Invalid username or password');
          }
        }
      }

      AppLogger.warning('Login failed: User not found - $name');
      return (false, 'Invalid username or password');
    } catch (e, stackTrace) {
      final error = AppError.authentication('Login failed: $e');
      AppLogger.error('Login error', error, stackTrace);
      return (false, error.message);
    }
  }

  /// Get admin by name (for display purposes)
  static String? getCurrentAdminName(String name) {
    try {
      final box = getAdminBox();

      for (final admin in box.values) {
        if (admin.name.toLowerCase() == name.toLowerCase()) {
          return admin.name;
        }
      }

      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current admin', e, stackTrace);
      return null;
    }
  }

  /// Get all registered admins
  static List<Admin> getAllAdmins() {
    try {
      final box = getAdminBox();
      return box.values.toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all admins', e, stackTrace);
      return [];
    }
  }

  /// Delete an admin by index
  static Future<(bool, String)> deleteAdmin(int index) async {
    try {
      final box = getAdminBox();
      if (index < 0 || index >= box.length) {
        return (false, 'Invalid admin index');
      }

      final adminName = box.getAt(index)?.name ?? 'Unknown';
      await box.deleteAt(index);
      AppLogger.auth('Admin deleted', details: 'Admin: $adminName');
      return (true, 'Admin deleted successfully');
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to delete admin: $e');
      AppLogger.error('Error deleting admin', error, stackTrace);
      return (false, error.message);
    }
  }

  /// Generate registration number based on month and sequence
  /// Format: [Month Initial][Year (2 digits)][Sequence]
  /// Example: J2601, J2602, F2601, etc.
  static String generateRegistrationNumber(
    String registrationMonth,
    int memberCount,
  ) {
    try {
      // Extract first letter of month and year (last 2 digits)
      final monthLetter = registrationMonth.isNotEmpty
          ? registrationMonth[0].toUpperCase()
          : 'J';

      final now = DateTime.now();
      final year = now.year.toString().substring(
        2,
      ); // Get last 2 digits: 26, 27, etc
      final sequence = memberCount + 1;

      return '$monthLetter$year$sequence';
    } catch (e, stackTrace) {
      AppLogger.error('Error generating registration number', e, stackTrace);
      return 'ERR${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
