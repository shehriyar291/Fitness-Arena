import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/app_error.dart';
import '../models/member.dart';
import '../utils/app_logger.dart';

/// Service class for managing Hive database operations
/// Handles all data persistence for members and related entities
class DatabaseService {
  static const String boxName = AppConstants.gymMembersBoxName;
  static const String monthTrackingBoxName = 'month_tracking';

  /// Initialize the Hive database with all necessary adapters
  static Future<void> initDatabase() async {
    try {
      AppLogger.database('Initializing database');
      await Hive.initFlutter();

      // Register all adapters
      Hive.registerAdapter(MemberAdapter());
      Hive.registerAdapter(PaymentRecordAdapter());
      Hive.registerAdapter(AttendanceRecordAdapter());

      AppLogger.database('Adapters registered successfully');

      // Check if box already exists
      if (!Hive.isBoxOpen(boxName)) {
        try {
          await Hive.openBox<Member>(boxName);
          AppLogger.database('Database box opened', details: 'Box: $boxName');
        } catch (e, stackTrace) {
          // If box is corrupted, delete it and create new
          AppLogger.warning(
            'Database box corrupted, recreating',
            e,
            stackTrace,
          );
          await Hive.deleteBoxFromDisk(boxName);
          await Hive.openBox<Member>(boxName);
          AppLogger.database('Database box recreated successfully');
        }
      }

      // Open month tracking box
      if (!Hive.isBoxOpen(monthTrackingBoxName)) {
        await Hive.openBox(monthTrackingBoxName);
        AppLogger.database('Month tracking box opened');
      }
    } catch (e, stackTrace) {
      final error = AppError.database('Database initialization failed: $e');
      AppLogger.error('Database initialization error', error, stackTrace);
      rethrow;
    }
  }

  /// Get the month tracking box
  static Box getMonthTrackingBox() {
    try {
      if (!Hive.isBoxOpen(monthTrackingBoxName)) {
        throw AppError.database('Month tracking box not initialized');
      }
      return Hive.box(monthTrackingBoxName);
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to get month tracking box: $e');
      AppLogger.error('Error getting month tracking box', error, stackTrace);
      rethrow;
    }
  }

  /// Get the member database box
  static Box<Member> getBox() {
    try {
      return Hive.box<Member>(boxName);
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to access database box: $e');
      AppLogger.error('Error getting box', error, stackTrace);
      rethrow;
    }
  }

  /// Add a new member to the database
  static Future<void> addMember(Member member) async {
    try {
      final box = getBox();
      await box.add(member);
      AppLogger.database('Member added', details: 'Member: ${member.name}');
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to add member: $e');
      AppLogger.error('Error adding member', error, stackTrace);
      rethrow;
    }
  }

  /// Update an existing member in the database
  static Future<void> updateMember(int index, Member member) async {
    try {
      final box = getBox();
      await box.putAt(index, member);
      AppLogger.database(
        'Member updated',
        details: 'Index: $index, Member: ${member.name}',
      );
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to update member: $e');
      AppLogger.error('Error updating member', error, stackTrace);
      rethrow;
    }
  }

  /// Delete a member from the database
  static Future<void> deleteMember(int index) async {
    try {
      final box = getBox();
      await box.deleteAt(index);
      AppLogger.database('Member deleted', details: 'Index: $index');
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to delete member: $e');
      AppLogger.error('Error deleting member', error, stackTrace);
      rethrow;
    }
  }

  /// Get all members from the database
  static List<Member> getAllMembers() {
    try {
      final box = getBox();
      return box.values.toList();
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to retrieve members: $e');
      AppLogger.error('Error getting all members', error, stackTrace);
      rethrow;
    }
  }

  /// Toggle the payment status of a member
  static Future<void> toggleFeeStatus(int index) async {
    try {
      final box = getBox();
      final member = box.getAt(index);
      if (member != null) {
        member.isPaid = !member.isPaid;
        await member.save();
        AppLogger.database(
          'Fee status toggled',
          details: 'Index: $index, Paid: ${member.isPaid}',
        );
      } else {
        throw AppError.notFound('Member at index $index not found');
      }
    } catch (e, stackTrace) {
      final error = AppError.database('Failed to toggle fee status: $e');
      AppLogger.error('Error toggling fee status', error, stackTrace);
      rethrow;
    }
  }

  /// Close the database
  static Future<void> closeDatabase() async {
    try {
      await Hive.close();
      AppLogger.database('Database closed');
    } catch (e, stackTrace) {
      AppLogger.warning('Error closing database', e, stackTrace);
    }
  }
}
