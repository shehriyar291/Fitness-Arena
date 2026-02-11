import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_logger.dart';

class LoginUIProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  bool passwordVisible = false;

  final VoidCallback onLoginSuccess;

  LoginUIProvider({required this.onLoginSuccess});

  void setPasswordVisible(bool v) {
    passwordVisible = v;
    notifyListeners();
  }

  void setError(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  Future<void> handleLogin() async {
    final name = nameController.text.trim();
    final password = passwordController.text;

    // basic validation
    if (name.isEmpty) {
      setError('Username is required');
      return;
    }
    if (password.isEmpty) {
      setError('Password is required');
      return;
    }

    setError(null);
    setLoading(true);

    try {
      AppLogger.auth('Attempting login: $name');
      final result = await AuthService.login(name, password);
      // AuthService returns (success, message) as a record
      final success = result.$1;
      final message = result.$2;

      if (success) {
        setLoading(false);
        // clear fields
        nameController.clear();
        passwordController.clear();
        onLoginSuccess();
      } else {
        setError(message);
        setLoading(false);
      }
    } catch (e, st) {
      AppLogger.error('Login error', e, st);
      setError('An error occurred during login. Please try again.');
      setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
