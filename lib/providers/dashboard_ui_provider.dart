import 'package:flutter/material.dart';

class DashboardUIProvider extends ChangeNotifier {
  DateTime _selectedMonth = DateTime.now();

  DateTime get selectedMonth => _selectedMonth;

  void setSelectedMonth(DateTime value) {
    _selectedMonth = value;
    notifyListeners();
  }

  void prevMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }
}
