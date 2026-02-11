import 'package:intl/intl.dart';
import '../models/member.dart';
import '../utils/app_logger.dart';
import '../models/app_error.dart';
import 'database_service.dart';

/// Service to handle automatic month-end processing
/// - Convert all members to unpaid status
/// - Carry over pending/unpaid charges to next month
class MonthManagementService {
  /// Get the current month in MM/yyyy format
  static String getCurrentMonth() {
    return DateFormat('MM/yyyy').format(DateTime.now());
  }

  /// Get the current month name
  static String getCurrentMonthName() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  /// Get previous month in MM/yyyy format
  static String getPreviousMonth() {
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1);
    return DateFormat('MM/yyyy').format(previous);
  }

  /// Check if it's a new month compared to stored last processed month
  /// Returns true if processing is needed
  static bool shouldProcessMonthChange() {
    try {
      final prefs = DatabaseService.getMonthTrackingBox();
      final lastProcessedMonth = prefs.get('lastProcessedMonth') as String?;
      final currentMonth = getCurrentMonth();

      if (lastProcessedMonth == null || lastProcessedMonth != currentMonth) {
        AppLogger.info(
          'New month detected: $currentMonth (last: $lastProcessedMonth)',
        );
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking month change',
        AppError.database('Failed to check month: $e'),
        stackTrace,
      );
      return false;
    }
  }

  /// Process month change for all members
  /// - Mark unpaid members' amounts as pending charges for next month
  /// - Reset all members to unpaid status
  /// - Preserve paid members' payment status until manually updated
  static Future<void> processMonthChange() async {
    try {
      AppLogger.info('Processing month change...');
      final currentMonth = getCurrentMonth();

      final members = DatabaseService.getAllMembers();

      for (int i = 0; i < members.length; i++) {
        final member = members[i];

        // Only process if member is active
        if (!member.isActive) {
          continue;
        }

        // If member was unpaid last month, add amount to pending charges
        if (!member.isPaid) {
          member.pendingCharges = member.pendingCharges + member.amount;
          member.lastChargeMonth = getPreviousMonth();
          AppLogger.database(
            'Member has unpaid fees',
            details:
                '${member.name}: ₹${member.amount} added to pending charges (total: ₹${member.pendingCharges})',
          );
        }

        // Reset all members to unpaid for new month
        member.isPaid = false;
        await member.save();
      }

      // Update the last processed month
      final prefs = DatabaseService.getMonthTrackingBox();
      await prefs.put('lastProcessedMonth', currentMonth);

      AppLogger.info(
        'Month change processing completed for $currentMonth with ${members.length} members',
      );
    } catch (e, stackTrace) {
      final error = AppError.database('Month change processing failed: $e');
      AppLogger.error('Error processing month change', error, stackTrace);
      rethrow;
    }
  }

  /// Get total pending charges for a specific member
  static double getMemberPendingCharges(Member member) {
    return member.pendingCharges;
  }

  /// Clear pending charges for a member
  /// This should be called when member pays up
  static Future<void> clearPendingCharges(int memberIndex) async {
    try {
      final box = DatabaseService.getBox();
      final member = box.getAt(memberIndex);
      if (member != null) {
        final clearedAmount = member.pendingCharges;
        member.pendingCharges = 0.0;
        member.lastChargeMonth = null;
        await member.save();
        AppLogger.database(
          'Pending charges cleared for ${member.name}: ₹$clearedAmount',
        );
      }
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to clear pending charges: $e');
      AppLogger.error('Error clearing pending charges', error, stackTrace);
      rethrow;
    }
  }

  /// Calculate total amount due for a member (current + pending)
  static double getTotalAmountDue(Member member) {
    return member.amount + member.pendingCharges;
  }

  /// Get members with pending charges in current month
  static List<Member> getMembersWithPendingCharges(List<Member> members) {
    return members
        .where((m) => m.isActive && m.pendingCharges > 0 && !m.isPaid)
        .toList();
  }

  /// Format pending charges information for display
  static String formatPendingChargesInfo(Member member) {
    if (member.pendingCharges <= 0) return '';

    final lastMonth = member.lastChargeMonth ?? 'Unknown';
    return 'Pending from $lastMonth: ₹${member.pendingCharges.toStringAsFixed(2)}';
  }

  /// Get month-wise breakdown of amounts due
  static Map<String, double> getMonthBreakdown(Member member) {
    final breakdown = <String, double>{};

    // Current month amount
    breakdown[getCurrentMonth()] = member.amount;

    // Pending charges from previous months
    if (member.pendingCharges > 0 && member.lastChargeMonth != null) {
      breakdown[member.lastChargeMonth!] = member.pendingCharges;
    }

    return breakdown;
  }
}
