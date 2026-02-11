/// Application-wide constants
class AppConstants {
  // Colors
  static const int primaryColorValue = 0xFF6B5DFF;
  static const int secondaryColorValue = 0xFF03DAC6;
  static const int errorColorValue = 0xFFB00020;

  // Strings - Filter Defaults
  static const String filterAll = 'All';

  // Database
  static const String gymMembersBoxName = 'gym_members';
  static const String gymAdminsBoxName = 'gym_admins';
  static const String authTokenKey = 'current_admin';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // Member Types
  static const List<String> memberTypes = ['Basic', 'Premium', 'VIP'];

  // Months
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Payment Methods
  static const List<String> paymentMethods = ['Cash', 'Card', 'UPI', 'Check'];

  // Error Messages
  static const String unknownError = 'An unknown error occurred';
  static const String databaseError = 'Database error';
  static const String authenticationError = 'Authentication failed';
  static const String validationError = 'Validation error';
  static const String operationFailed = 'Operation failed';

  // Success Messages
  static const String memberAdded = 'Member added successfully';
  static const String memberUpdated = 'Member updated successfully';
  static const String memberDeleted = 'Member deleted successfully';
  static const String signupSuccess = 'Signup successful';
  static const String loginSuccess = 'Login successful';
}
