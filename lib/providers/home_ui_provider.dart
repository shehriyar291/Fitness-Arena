import 'package:flutter/foundation.dart';

class HomeUIProvider extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedMonth = 'All';
  String _selectedYear = 'All';
  final Map<String, bool> _expanded = {};

  String get searchQuery => _searchQuery;
  String get selectedMonth => _selectedMonth;
  String get selectedYear => _selectedYear;

  bool isExpanded(String id) => _expanded[id] ?? false;

  void setSearchQuery(String q) {
    if (_searchQuery == q) return;
    _searchQuery = q;
    notifyListeners();
  }

  void setSelectedMonth(String month) {
    if (_selectedMonth == month) return;
    _selectedMonth = month;
    notifyListeners();
  }

  void setSelectedYear(String year) {
    if (_selectedYear == year) return;
    _selectedYear = year;
    notifyListeners();
  }

  void toggleExpanded(String id) {
    _expanded[id] = !(_expanded[id] ?? true);
    notifyListeners();
  }

  void setExpanded(String id, bool value) {
    _expanded[id] = value;
    notifyListeners();
  }
}
