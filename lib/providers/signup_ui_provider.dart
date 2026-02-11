import 'package:flutter/material.dart';
import '../constants/validators.dart';
import '../services/auth_service.dart';
import '../utils/app_logger.dart';

class SignupUIProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  SignupUIProvider();

  void setPasswordVisible(bool v) {
    passwordVisible = v;
    notifyListeners();
  }

  void setConfirmPasswordVisible(bool v) {
    confirmPasswordVisible = v;
    notifyListeners();
  }

  void setError(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void setSuccess(String? msg) {
    successMessage = msg;
    notifyListeners();
  }

  void setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  Future<void> handleSignup() async {
    setError(null);
    setSuccess(null);

    final name = nameController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    final nameError = Validators.validateName(name);
    final passwordError = Validators.validatePassword(password);
    final passwordMatchError = Validators.validatePasswordMatch(
      password,
      confirm,
    );

    if (nameError != null) {
      setError(nameError);
      return;
    }
    if (passwordError != null) {
      setError(passwordError);
      return;
    }
    if (passwordMatchError != null) {
      setError(passwordMatchError);
      return;
    }

    setLoading(true);

    try {
      AppLogger.auth('Attempting signup: $name');
      final result = await AuthService.signup(name, password);
      final success = result.$1;
      final message = result.$2;

      if (success) {
        setSuccess(message);
        setLoading(false);
      } else {
        setError(message);
        setLoading(false);
      }
    } catch (e, st) {
      AppLogger.error('Signup error', e, st);
      setError('An error occurred during signup. Please try again.');
      setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
