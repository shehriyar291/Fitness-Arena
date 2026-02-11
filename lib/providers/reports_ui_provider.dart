import 'package:flutter/foundation.dart';

class ReportsUIProvider extends ChangeNotifier {
  String _selectedReportType = 'All Members';

  String get selectedReportType => _selectedReportType;

  void setSelectedReportType(String type) {
    if (_selectedReportType == type) return;
    _selectedReportType = type;
    notifyListeners();
  }
}
