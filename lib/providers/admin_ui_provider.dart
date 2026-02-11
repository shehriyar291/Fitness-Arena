import 'package:flutter/material.dart';
import '../models/admin.dart';
import '../services/auth_service.dart';

class AdminUIProvider extends ChangeNotifier {
  List<Admin> _admins = [];

  AdminUIProvider() {
    _loadAdmins();
  }

  List<Admin> get admins => _admins;

  Future<void> _loadAdmins() async {
    _admins = AuthService.getAllAdmins();
    notifyListeners();
  }

  Future<bool> deleteAdmin(int index) async {
    try {
      await AuthService.deleteAdmin(index);
      _admins = AuthService.getAllAdmins();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
