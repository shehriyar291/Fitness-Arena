import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../lib/models/member.dart';
import '../lib/services/month_management_service.dart';

void main() {
  group('MonthManagementService', () {
    group('Month Information', () {
      test('getCurrentMonth returns correct format MM/yyyy', () {
        final month = MonthManagementService.getCurrentMonth();
        final regex = RegExp(r'^\d{2}/\d{4}$');
        expect(month, matches(regex));
      });

      test('getCurrentMonthName returns month name', () {
        final name = MonthManagementService.getCurrentMonthName();
        final monthNames = [
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
        expect(monthNames, contains(name));
      });

      test('getPreviousMonth returns previous month', () {
        final now = DateTime.now();
        final previous = DateTime(now.year, now.month - 1);
        final expected = DateFormat('MM/yyyy').format(previous);
        final actual = MonthManagementService.getPreviousMonth();
        expect(actual, equals(expected));
      });
    });

    group('Pending Charges', () {
      test('getMemberPendingCharges returns correct amount', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 250,
        );

        final pending = MonthManagementService.getMemberPendingCharges(member);
        expect(pending, equals(250));
      });

      test('getTotalAmountDue calculates current + pending', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 300,
        );

        final total = MonthManagementService.getTotalAmountDue(member);
        expect(total, equals(800)); // 500 + 300
      });

      test('getTotalAmountDue returns only current amount when no pending', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 0,
        );

        final total = MonthManagementService.getTotalAmountDue(member);
        expect(total, equals(500));
      });
    });

    group('Filtering', () {
      test(
        'getMembersWithPendingCharges returns only members with pending > 0',
        () {
          final members = [
            Member(
              name: 'Member 1',
              address: 'Address 1',
              amount: 500,
              isPaid: false,
              registrationMonth: 'January',
              registrationDate: DateTime(2026, 1, 1),
              registrationNumber: 'J20261',
              pendingCharges: 200,
              isActive: true,
            ),
            Member(
              name: 'Member 2',
              address: 'Address 2',
              amount: 500,
              isPaid: false,
              registrationMonth: 'January',
              registrationDate: DateTime(2026, 1, 1),
              registrationNumber: 'J20262',
              pendingCharges: 0,
              isActive: true,
            ),
            Member(
              name: 'Member 3',
              address: 'Address 3',
              amount: 500,
              isPaid: true,
              registrationMonth: 'January',
              registrationDate: DateTime(2026, 1, 1),
              registrationNumber: 'J20263',
              pendingCharges: 300,
              isActive: true,
            ),
          ];

          final withPending =
              MonthManagementService.getMembersWithPendingCharges(members);
          expect(withPending, hasLength(1));
          expect(withPending.first.name, equals('Member 1'));
        },
      );

      test('getMembersWithPendingCharges excludes inactive members', () {
        final members = [
          Member(
            name: 'Active Member',
            address: 'Address 1',
            amount: 500,
            isPaid: false,
            registrationMonth: 'January',
            registrationDate: DateTime(2026, 1, 1),
            registrationNumber: 'J20261',
            pendingCharges: 200,
            isActive: true,
          ),
          Member(
            name: 'Inactive Member',
            address: 'Address 2',
            amount: 500,
            isPaid: false,
            registrationMonth: 'January',
            registrationDate: DateTime(2026, 1, 1),
            registrationNumber: 'J20262',
            pendingCharges: 300,
            isActive: false,
          ),
        ];

        final withPending = MonthManagementService.getMembersWithPendingCharges(
          members,
        );
        expect(withPending, hasLength(1));
        expect(withPending.first.name, equals('Active Member'));
      });
    });

    group('Formatting', () {
      test('formatPendingChargesInfo returns empty string when no pending', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 0,
        );

        final info = MonthManagementService.formatPendingChargesInfo(member);
        expect(info, isEmpty);
      });

      test(
        'formatPendingChargesInfo returns formatted string with pending',
        () {
          final member = Member(
            name: 'Test Member',
            address: 'Test Address',
            amount: 500,
            isPaid: false,
            registrationMonth: 'January',
            registrationDate: DateTime(2026, 1, 1),
            registrationNumber: 'J20261',
            pendingCharges: 250,
            lastChargeMonth: '01/2026',
          );

          final info = MonthManagementService.formatPendingChargesInfo(member);
          expect(info, contains('01/2026'));
          expect(info, contains('250.00'));
        },
      );

      test('formatPendingChargesInfo handles unknown last month', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 250,
        );

        final info = MonthManagementService.formatPendingChargesInfo(member);
        expect(info, contains('Unknown'));
      });
    });

    group('Month Breakdown', () {
      test('getMonthBreakdown includes only current month when no pending', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 0,
        );

        final breakdown = MonthManagementService.getMonthBreakdown(member);
        expect(breakdown, hasLength(1));
        expect(breakdown.values.first, equals(500));
      });

      test('getMonthBreakdown includes current and pending months', () {
        final member = Member(
          name: 'Test Member',
          address: 'Test Address',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 300,
          lastChargeMonth: '01/2026',
        );

        final breakdown = MonthManagementService.getMonthBreakdown(member);
        expect(breakdown, hasLength(2));
        expect(breakdown.containsValue(500), isTrue);
        expect(breakdown.containsValue(300), isTrue);
      });

      test(
        'getMonthBreakdown excludes pending month when lastChargeMonth null',
        () {
          final member = Member(
            name: 'Test Member',
            address: 'Test Address',
            amount: 500,
            isPaid: false,
            registrationMonth: 'January',
            registrationDate: DateTime(2026, 1, 1),
            registrationNumber: 'J20261',
            pendingCharges: 300,
          );

          final breakdown = MonthManagementService.getMonthBreakdown(member);
          expect(breakdown, hasLength(1));
          expect(breakdown.values.first, equals(500));
        },
      );
    });

    group('Member Scenarios', () {
      test('Scenario: Regular unpaid member gets pending charges', () {
        // Simulating month change
        final member = Member(
          name: 'Raj Kumar',
          address: 'Main Street',
          amount: 500,
          isPaid: false, // Was unpaid
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
        );

        // Month changes - member gets pending charges added
        member.pendingCharges = member.pendingCharges + member.amount;
        member.lastChargeMonth = '01/2026';
        member.isPaid = false;

        expect(member.pendingCharges, equals(500));
        expect(member.lastChargeMonth, equals('01/2026'));
        expect(
          MonthManagementService.getTotalAmountDue(member),
          equals(1000),
        ); // 500 current + 500 pending
      });

      test('Scenario: Member with multiple months unpaid', () {
        final member = Member(
          name: 'Priya Singh',
          address: 'Park Road',
          amount: 500,
          isPaid: false,
          registrationMonth: 'December',
          registrationDate: DateTime(2025, 12, 1),
          registrationNumber: 'D20251',
          pendingCharges: 1000, // Already has 2 months pending
          lastChargeMonth: '01/2026',
        );

        // Third unpaid month
        member.pendingCharges = member.pendingCharges + member.amount;

        expect(member.pendingCharges, equals(1500));
        expect(
          MonthManagementService.getTotalAmountDue(member),
          equals(2000),
        ); // 500 + 1500
      });

      test('Scenario: Member pays full amount including pending', () {
        final member = Member(
          name: 'John Doe',
          address: 'Hill Street',
          amount: 500,
          isPaid: false,
          registrationMonth: 'January',
          registrationDate: DateTime(2026, 1, 1),
          registrationNumber: 'J20261',
          pendingCharges: 500, // Previous month pending
          lastChargeMonth: '01/2026',
        );

        // Member pays full amount
        final totalDue = MonthManagementService.getTotalAmountDue(member);
        expect(totalDue, equals(1000)); // Can pay in full

        // After payment
        member.isPaid = true;
        member.pendingCharges = 0;
        member.lastChargeMonth = null;

        expect(member.pendingCharges, equals(0));
        expect(member.isPaid, isTrue);
      });
    });
  });
}
