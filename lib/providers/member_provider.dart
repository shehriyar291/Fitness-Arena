import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/app_error.dart';
import '../models/member.dart';
import '../services/database_service.dart';
import '../services/month_management_service.dart';
import '../utils/app_logger.dart';

/// Provider for managing member data and business logic
/// Handles CRUD operations and filtering with proper error handling
class MemberProvider extends ChangeNotifier {
  late Box<Member> _box;
  String? _lastError;

  MemberProvider() {
    _box = DatabaseService.getBox();
  }

  /// Get all members
  List<Member> get members => _box.values.toList();

  /// Get last error message if any
  String? get lastError => _lastError;

  /// Clear last error
  void clearError() {
    _lastError = null;
  }

  /// Add a new member with error handling
  Future<bool> addMember(Member member) async {
    try {
      clearError();
      AppLogger.ui('Adding new member: ${member.name}');
      await DatabaseService.addMember(member);
      notifyListeners();
      AppLogger.ui('Member added successfully');
      return true;
    } on AppError catch (e) {
      _lastError = e.message;
      AppLogger.error('Failed to add member', e);
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to add member: $e');
      _lastError = error.message;
      AppLogger.error('Unexpected error adding member', error, stackTrace);
      notifyListeners();
      return false;
    }
  }

  /// Update an existing member with error handling
  Future<bool> updateMember(int index, Member member) async {
    try {
      clearError();
      AppLogger.ui('Updating member at index $index: ${member.name}');
      await DatabaseService.updateMember(index, member);
      notifyListeners();
      AppLogger.ui('Member updated successfully');
      return true;
    } on AppError catch (e) {
      _lastError = e.message;
      AppLogger.error('Failed to update member', e);
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to update member: $e');
      _lastError = error.message;
      AppLogger.error('Unexpected error updating member', error, stackTrace);
      notifyListeners();
      return false;
    }
  }

  /// Delete a member with error handling
  Future<bool> deleteMember(int index) async {
    try {
      clearError();
      AppLogger.ui('Deleting member at index $index');
      await DatabaseService.deleteMember(index);
      notifyListeners();
      AppLogger.ui('Member deleted successfully');
      return true;
    } on AppError catch (e) {
      _lastError = e.message;
      AppLogger.error('Failed to delete member', e);
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to delete member: $e');
      _lastError = error.message;
      AppLogger.error('Unexpected error deleting member', error, stackTrace);
      notifyListeners();
      return false;
    }
  }

  /// Toggle fee payment status with error handling
  Future<bool> toggleFeeStatus(int index) async {
    try {
      clearError();
      AppLogger.ui('Toggling fee status for member at index $index');
      await DatabaseService.toggleFeeStatus(index);
      notifyListeners();
      AppLogger.ui('Fee status toggled successfully');
      return true;
    } on AppError catch (e) {
      _lastError = e.message;
      AppLogger.error('Failed to toggle fee status', e);
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to toggle fee status: $e');
      _lastError = error.message;
      AppLogger.error(
        'Unexpected error toggling fee status',
        error,
        stackTrace,
      );
      notifyListeners();
      return false;
    }
  }

  /// Filter members by search query, month, and year
  /// Returns filtered list based on criteria
  List<Member> filterMembers({
    String searchQuery = '',
    String? selectedMonth,
    String? selectedYear,
  }) {
    try {
      var filtered = members;

      // Filter by search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered = filtered.where((member) {
          return member.name.toLowerCase().contains(query) ||
              member.registrationNumber.toLowerCase().contains(query) ||
              member.address.toLowerCase().contains(query) ||
              (member.phone?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      // Filter by year
      if (selectedYear != null && selectedYear != 'All') {
        filtered = filtered
            .where(
              (member) =>
                  member.registrationDate.year.toString() == selectedYear,
            )
            .toList();
      }

      // Filter by month
      if (selectedMonth != null && selectedMonth != 'All') {
        filtered = filtered
            .where((member) => member.registrationMonth == selectedMonth)
            .toList();
      }

      return filtered;
    } catch (e, stackTrace) {
      AppLogger.error('Error filtering members', e, stackTrace);
      return [];
    }
  }

  /// Get member count for statistics
  int getMemberCount() {
    try {
      return members.length;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting member count', e, stackTrace);
      return 0;
    }
  }

  /// Get members who have paid their fees
  List<Member> getPaidMembers() {
    try {
      return members.where((member) => member.isPaid).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting paid members', e, stackTrace);
      return [];
    }
  }

  /// Get members with unpaid fees
  List<Member> getUnpaidMembers() {
    try {
      return members.where((member) => !member.isPaid).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting unpaid members', e, stackTrace);
      return [];
    }
  }

  /// Get active members
  List<Member> getActiveMembers() {
    try {
      return members.where((member) => member.isActive).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting active members', e, stackTrace);
      return [];
    }
  }

  /// Calculate total revenue from all members
  double calculateTotalRevenue() {
    try {
      return members.fold(0, (sum, member) => sum + member.amount);
    } catch (e, stackTrace) {
      AppLogger.error('Error calculating total revenue', e, stackTrace);
      return 0;
    }
  }

  /// Get total amount due (current month + pending charges)
  double getTotalAmountDue(int memberIndex) {
    try {
      final member = _box.getAt(memberIndex);
      if (member == null) return 0;
      return MonthManagementService.getTotalAmountDue(member);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting total amount due', e, stackTrace);
      return 0;
    }
  }

  /// Get members with pending charges
  List<Member> getMembersWithPendingCharges() {
    try {
      return MonthManagementService.getMembersWithPendingCharges(members);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting members with pending charges',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Clear pending charges for a member
  Future<bool> clearPendingCharges(int memberIndex) async {
    try {
      clearError();
      AppLogger.ui('Clearing pending charges for member at index $memberIndex');
      await MonthManagementService.clearPendingCharges(memberIndex);
      notifyListeners();
      AppLogger.ui('Pending charges cleared successfully');
      return true;
    } on AppError catch (e) {
      _lastError = e.message;
      AppLogger.error('Failed to clear pending charges', e);
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to clear pending charges: $e');
      _lastError = error.message;
      AppLogger.error(
        'Unexpected error clearing pending charges',
        error,
        stackTrace,
      );
      notifyListeners();
      return false;
    }
  }

  /// Get total pending charges across all members
  double calculateTotalPendingCharges() {
    try {
      final pending = members.fold<double>(
        0,
        (sum, member) => sum + member.pendingCharges,
      );
      return pending;
    } catch (e, stackTrace) {
      AppLogger.error('Error calculating total pending charges', e, stackTrace);
      return 0;
    }
  }
}
