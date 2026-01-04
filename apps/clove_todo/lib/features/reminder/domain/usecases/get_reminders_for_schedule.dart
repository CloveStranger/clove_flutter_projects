import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case for getting all reminders associated with a specific schedule
class GetRemindersForSchedule implements UseCase<List<Reminder>, GetRemindersForScheduleParams> {
  final ReminderRepository repository;

  const GetRemindersForSchedule(this.repository);

  @override
  Future<Either<Failure, List<Reminder>>> call(GetRemindersForScheduleParams params) async {
    try {
      // Validate the schedule ID
      if (params.scheduleId.trim().isEmpty) {
        return Left(ValidationFailure('Schedule ID cannot be empty'));
      }

      // Get reminders for the schedule
      final result = await repository.getRemindersForSchedule(params.scheduleId);

      return result.fold((failure) => Left(failure), (reminders) {
        // Apply filters if specified
        List<Reminder> filteredReminders = reminders;

        if (params.activeOnly) {
          filteredReminders = filteredReminders.where((reminder) => !reminder.isTriggered).toList();
        }

        if (params.triggeredOnly) {
          filteredReminders = filteredReminders.where((reminder) => reminder.isTriggered).toList();
        }

        if (params.upcomingOnly) {
          filteredReminders = filteredReminders.where((reminder) => reminder.isUpcoming()).toList();
        }

        if (params.dueOnly) {
          filteredReminders = filteredReminders.where((reminder) => reminder.isDue()).toList();
        }

        // Sort reminders by reminder time if requested
        if (params.sortByTime) {
          filteredReminders.sort((a, b) => a.remindTime.compareTo(b.remindTime));
        }

        return Right(filteredReminders);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to get reminders for schedule: ${e.toString()}'));
    }
  }
}

/// Parameters for GetRemindersForSchedule use case
class GetRemindersForScheduleParams extends Equatable {
  final String scheduleId;
  final bool activeOnly; // Only non-triggered reminders
  final bool triggeredOnly; // Only triggered reminders
  final bool upcomingOnly; // Only upcoming reminders (within next hour)
  final bool dueOnly; // Only due reminders (should be triggered now)
  final bool sortByTime; // Sort by reminder time

  const GetRemindersForScheduleParams({
    required this.scheduleId,
    this.activeOnly = false,
    this.triggeredOnly = false,
    this.upcomingOnly = false,
    this.dueOnly = false,
    this.sortByTime = true,
  });

  @override
  List<Object?> get props => [scheduleId, activeOnly, triggeredOnly, upcomingOnly, dueOnly, sortByTime];
}
