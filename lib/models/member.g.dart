// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final int typeId = 0;

  @override
  Member read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Member(
      name: fields[0] as String,
      address: fields[1] as String,
      amount: fields[2] as double,
      isPaid: fields[3] as bool,
      registrationMonth: fields[4] as String,
      registrationDate: fields[5] as DateTime,
      memberType: fields[6] as String?,
      phone: fields[7] as String?,
      paymentHistory: (fields[8] as List?)?.cast<PaymentRecord>(),
      attendanceRecords: (fields[9] as List?)?.cast<AttendanceRecord>(),
      membershipExpiryDate: fields[10] as DateTime?,
      isActive: fields[11] as bool,
      idCardNumber: fields[12] as String?,
      registrationNumber: fields[13] as String,
      fatherName: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Member obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.isPaid)
      ..writeByte(4)
      ..write(obj.registrationMonth)
      ..writeByte(5)
      ..write(obj.registrationDate)
      ..writeByte(6)
      ..write(obj.memberType)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.paymentHistory)
      ..writeByte(9)
      ..write(obj.attendanceRecords)
      ..writeByte(10)
      ..write(obj.membershipExpiryDate)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.idCardNumber)
      ..writeByte(13)
      ..write(obj.registrationNumber)
      ..writeByte(14)
      ..write(obj.fatherName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentRecordAdapter extends TypeAdapter<PaymentRecord> {
  @override
  final int typeId = 1;

  @override
  PaymentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentRecord(
      paymentDate: fields[0] as DateTime,
      amount: fields[1] as double,
      paymentMethod: fields[2] as String,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.paymentDate)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.paymentMethod)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttendanceRecordAdapter extends TypeAdapter<AttendanceRecord> {
  @override
  final int typeId = 2;

  @override
  AttendanceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceRecord(
      checkInTime: fields[0] as DateTime,
      checkOutTime: fields[1] as DateTime?,
      notes: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.checkInTime)
      ..writeByte(1)
      ..write(obj.checkOutTime)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
