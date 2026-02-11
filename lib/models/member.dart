import 'package:hive/hive.dart';

part 'member.g.dart';

@HiveType(typeId: 0)
class Member extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  @HiveField(2)
  double amount;

  @HiveField(3)
  bool isPaid;

  @HiveField(4)
  String registrationMonth;

  @HiveField(5)
  DateTime registrationDate;

  @HiveField(6)
  String? memberType; // Basic, Premium, VIP

  @HiveField(7)
  String? phone;

  @HiveField(8)
  List<PaymentRecord>? paymentHistory;

  @HiveField(9)
  List<AttendanceRecord>? attendanceRecords;

  @HiveField(10)
  DateTime? membershipExpiryDate;

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  String? idCardNumber; // Unique ID card number

  @HiveField(13)
  String registrationNumber; // Auto-generated like J20261, J20262

  @HiveField(14)
  String? fatherName; // Father's name

  @HiveField(15)
  double pendingCharges; // Charges carried from previous month

  @HiveField(16)
  String? lastChargeMonth; // Month when charges were added (MM/yyyy format)

  Member({
    required this.name,
    required this.address,
    required this.amount,
    required this.isPaid,
    required this.registrationMonth,
    required this.registrationDate,
    this.memberType = 'Basic',
    this.phone,
    this.paymentHistory,
    this.attendanceRecords,
    this.membershipExpiryDate,
    this.isActive = true,
    this.idCardNumber,
    required this.registrationNumber,
    this.fatherName,
    this.pendingCharges = 0.0,
    this.lastChargeMonth,
  });
}

@HiveType(typeId: 1)
class PaymentRecord extends HiveObject {
  @HiveField(0)
  DateTime paymentDate;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String paymentMethod; // Cash, Card, UPI, etc.

  @HiveField(3)
  String? notes;

  PaymentRecord({
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.notes,
  });
}

@HiveType(typeId: 2)
class AttendanceRecord extends HiveObject {
  @HiveField(0)
  DateTime checkInTime;

  @HiveField(1)
  DateTime? checkOutTime;

  @HiveField(2)
  String notes;

  AttendanceRecord({
    required this.checkInTime,
    this.checkOutTime,
    this.notes = '',
  });
}
