import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reminder.dart';

/// Repository interface for reminder management operations
abstract class ReminderRepository {
  /// Get all reminders for a specific schedule
  Future<Either<Failure, List<Reminder>>> getRemindersForSchedule(String scheduleId);

  /// Get a specific reminder by ID
  Future<Either<Failure, Reminder>> getReminderById(String id);

  /// Add a new reminder
  Future<Either<Failure, Reminder>> addReminder(Reminder reminder);

  /// Update an existing reminder
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);

  /// Cancel (delete) a reminder
  Future<Either<Failure, void>> cancelReminder(String id);

  /// Mark a reminder as triggered
  Future<Either<Failure, Reminder>> markReminderAsTriggered(String id);

  /// Get all due reminders (should be triggered now)
  Future<Either<Failure, List<Reminder>>> getDueReminders();

  /// Get upcoming reminders (within next hour)
  Future<Either<Failure, List<Reminder>>> getUpcomingReminders();

  /// Get all active (not triggered) reminders
  Future<Either<Failure, List<Reminder>>> getActiveReminders();

  /// Get triggered reminders
  Future<Either<Failure, List<Reminder>>> getTriggeredReminders();

  /// Batch operations
  Future<Either<Failure, List<Reminder>>> addReminders(List<Reminder> reminders);
  Future<Either<Failure, void>> cancelRemindersForSchedule(String scheduleId);

  /// Template management
  Future<Either<Failure, List<ReminderTemplate>>> getReminderTemplates();
  Future<Either<Failure, ReminderTemplate>> getReminderTemplateById(String id);
  Future<Either<Failure, ReminderTemplate>> addReminderTemplate(ReminderTemplate template);
  Future<Either<Failure, ReminderTemplate>> updateReminderTemplate(ReminderTemplate template);
  Future<Either<Failure, void>> deleteReminderTemplate(String id);

  /// Get default reminder templates
  Future<Either<Failure, List<ReminderTemplate>>> getDefaultReminderTemplates();

  /// Apply a template to create a reminder for a schedule
  Future<Either<Failure, Reminder>> applyReminderTemplate({
    required String templateId,
    required String scheduleId,
    required DateTime scheduleStartTime,
  });

  /// Get reminders modified after a specific timestamp (for sync)
  Future<Either<Failure, List<Reminder>>> getRemindersModifiedAfter(DateTime timestamp);

  /// Get reminder templates modified after a specific timestamp (for sync)
  Future<Either<Failure, List<ReminderTemplate>>> getTemplatesModifiedAfter(DateTime timestamp);

  /// Statistics
  Future<Either<Failure, int>> getReminderCount();
  Future<Either<Failure, int>> getTemplateCount();
  Future<Either<Failure, Map<String, int>>> getReminderStatistics();
}
