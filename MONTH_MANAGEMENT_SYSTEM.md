# 📅 Month Management System - Automatic Billing & Charge Carryover

## Overview

The system now includes **automatic month-end processing** that:
1. ✅ Converts all registered customers to **unpaid** status when the month changes
2. ✅ Adds **previous unpaid charges** to the next month's pending balance
3. ✅ Tracks pending charges separately so customers know total amount due
4. ✅ Automatically processes on app startup when a new month is detected

## How It Works

### 1. Month Change Detection
- **Trigger**: Occurs on app startup when month changes
- **Detection**: Compares current month (MM/yyyy) with last processed month stored in database
- **Automatic**: No manual action needed - happens on app launch

### 2. Month-End Processing
When the system detects a new month:

#### For Unpaid Members:
```
Previous Month:
├─ Member: Raj Kumar
├─ Fee: ₹500
└─ Status: UNPAID

Month Changes ↓

Current Month:
├─ Member: Raj Kumar
├─ Current Fee: ₹500
├─ Previous Pending: ₹500
├─ Total Due: ₹1000
└─ Status: UNPAID (reset)
```

#### For Paid Members:
```
Previous Month:
├─ Member: Priya Singh
├─ Fee: ₹500
└─ Status: PAID

Month Changes ↓

Current Month:
├─ Member: Priya Singh
├─ Current Fee: ₹500
├─ Pending: ₹0 (only current charges)
└─ Status: UNPAID (reset for new month)
```

### 3. Pending Charges Tracking

**New Member Fields:**
```
pendingCharges: double   // Total charges carried from previous months
lastChargeMonth: String  // When the pending charges were added (MM/yyyy)
```

**Example:**
- Registered: January, Fee: ₹500
- Jan 31: Member doesn't pay → Status: UNPAID
- Feb 1: Auto month-end processing
  - pendingCharges = ₹500
  - lastChargeMonth = "01/2026"
  - isPaid = false
  - Fee reset: ₹500
  - **Total Due: ₹1000**

## Key Features

### Automatic Processing
```dart
// Happens in main.dart on startup
if (MonthManagementService.shouldProcessMonthChange()) {
  await MonthManagementService.processMonthChange();
}
```

### Amount Calculation
```dart
// Total amount member owes
double totalDue = member.amount + member.pendingCharges;

Example:
- Current Month Fee: ₹500
- Pending from January: ₹500
- Pending from December: ₹300
- Total Due: ₹1300
```

### Dashboard Display
New metrics added:
- **Total Pending Charges**: Sum of all members' pending charges
- **Members with Arrears**: Count of members with pending charges
- **Collection Breakdown**: Current vs Previous months' dues

## Usage Scenarios

### Scenario 1: Regular Member (Pays on Time)
```
Jan: Fee ₹500 → Paid ✓
Feb 1: Auto reset to UNPAID, pendingCharges = 0
Feb: Fee ₹500 → Pays ✓ (no arrears)
```

### Scenario 2: Member with Pending Payment
```
Jan: Fee ₹500 → UNPAID ✗
Feb 1: Auto month-end
  - pendingCharges += ₹500
  - totalDue = ₹1000 (₹500 + ₹500)
  - Status: UNPAID
Feb: Pays ₹1000 total
  - pendingCharges cleared
  - isPaid = true
```

### Scenario 3: Multiple Months Unpaid
```
Jan: ₹500 UNPAID
Feb 1: pendingCharges = ₹500, currentFee = ₹500
Feb: UNPAID
Mar 1: pendingCharges = ₹1000, currentFee = ₹500
Mar: Member pays ₹1500
  - Covers Jan (₹500) + Feb (₹500) + Mar current (₹500)
  - pendingCharges cleared
```

## API Reference

### MonthManagementService

#### Detect Month Change
```dart
bool shouldProcess = MonthManagementService.shouldProcessMonthChange();
```

#### Process Month End
```dart
await MonthManagementService.processMonthChange();
// - Marks unpaid members as having pending charges
// - Resets all members to unpaid for new month
// - Updates last processed month
```

#### Get Current Month
```dart
String month = MonthManagementService.getCurrentMonth(); // "02/2026"
String name = MonthManagementService.getCurrentMonthName(); // "February"
```

#### Calculate Total Due
```dart
double total = MonthManagementService.getTotalAmountDue(member);
// Returns: current month fee + pending charges
```

#### Get Members with Arrears
```dart
List<Member> arrears = MonthManagementService.getMembersWithPendingCharges(members);
```

#### Clear Pending Charges
```dart
await MonthManagementService.clearPendingCharges(memberIndex);
// Called when member pays off all dues
```

#### Format Pending Info
```dart
String info = MonthManagementService.formatPendingChargesInfo(member);
// Returns: "Pending from 01/2026: ₹500"
```

## Database Changes

### Month Tracking Box
```dart
Box: month_tracking
Contents:
- lastProcessedMonth: "02/2026" (updated each month)
```

### Member Model Updates
```dart
@HiveField(15)
double pendingCharges;        // Charges from previous months

@HiveField(16)
String? lastChargeMonth;      // When charges were added
```

## Dashboard Integration

### New Cards/Metrics
1. **Pending Charges Card**: Total amount owed from previous months
2. **Arrears Members**: Count of members with pending charges
3. **Collection Target**: Current month + recoverable arrears

### Payment Status Display
```
Member Card shows:
- Current Month Fee: ₹500
- If pendingCharges > 0:
  - "Pending from Jan 2026: ₹500"
  - Total Due: ₹1000
  - Color: Orange (needs attention)
```

## Implementation Flow

```
App Launch
    ↓
Initialize Database
    ↓
Check: New Month?
    ├─ NO → Continue normally
    └─ YES ↓
       Process Month End
       ├─ For each UNPAID member:
       │  ├─ Add amount to pendingCharges
       │  └─ Update lastChargeMonth
       ├─ Reset all members: isPaid = false
       └─ Update lastProcessedMonth
    ↓
Load Main App
```

## Testing the System

### Test Case 1: Month Change Detection
```
1. Add members (Jan registration)
2. Mark some as PAID, some as UNPAID
3. Change system date to next month
4. Restart app
5. Verify:
   - All members show isPaid = false
   - UNPAID members have pendingCharges > 0
   - PAID members have pendingCharges = 0
```

### Test Case 2: Multiple Months
```
1. Add members in January
2. Don't pay in January
3. Month advances to February
4. Restart app → pendingCharges = ₹500
5. Don't pay in February
6. Month advances to March
7. Restart app → pendingCharges = ₹1000
```

### Test Case 3: Payment Recovery
```
1. Member has pendingCharges = ₹500
2. Member pays full amount
3. Toggle paid status
4. Clear pending charges
5. Verify: pendingCharges = 0
```

## Future Enhancements

- [ ] SMS reminders for members with pending charges
- [ ] Automatic payment reminders at month-end
- [ ] Payment plans for large arrears
- [ ] Late fee calculations
- [ ] Payment recovery reports
- [ ] Pending charges history per member
- [ ] Batch payment processing
- [ ] Export arrears list to PDF

## Important Notes

⚠️ **Key Behaviors:**
1. **Automatic Reset**: Every month ALL members reset to UNPAID
2. **Charge Accumulation**: Unpaid amounts accumulate, they don't reset
3. **One-way Carryover**: Charges only carry forward, never backward
4. **Manual Payment**: Only manual toggle can mark as PAID
5. **Pending Preservation**: Pending charges preserved even after payment status toggle

✅ **Benefits:**
- No manual month-end work
- Clear visibility of total customer debt
- Prevents revenue loss from forgotten payments
- Encourages regular payment collection
- Supports payment plans and recovery
