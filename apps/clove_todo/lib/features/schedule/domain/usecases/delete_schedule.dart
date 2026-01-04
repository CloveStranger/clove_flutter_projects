import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/schedule_repository.dart';
import '../../../reminder/domain/repositories/reminder_repository.dart';

/// Use case for deleting a schedule with reminder cleanup
class DeleteSchedule implements UseCase<void, DeleteScheduleParams> {
  final ScheduleRepository scheduleRepository;
  final ReminderRepository reminderRepository;

  const DeleteSchedule(this.scheduleRepository, this.reminderRepository);

  @override
  Future<Either<Failure, void>> call(DeleteScheduleParams params) async {
    try {
      // First, verify the schedule exists
      final scheduleResult = await scheduleRepository.getScheduleById(params.id);

      return scheduleResult.fold((failure) => Left(failure), (schedule) async {
        // Cancel all reminders for this schedule first
        if (params.cleanupReminders) {
          final reminderCleanupResult = await reminderRepository.cancelRemindersForSchedule(params.id);

          // If reminder cleanup fails, we can still proceed with schedule deletion
          // but log the failure for debugging
          reminderCleanupResult.fold(
            (failure) {
              // Log the failure but don't stop the deletion process
              // TODO: Use proper logging service instead of print
            },
            (_) {
              // Reminders cleaned up successfully
            },
          );
        }

        // Delete the schedule
        final deleteResult = await scheduleRepository.deleteSchedule(params.id);

        return deleteResult.fold((failure) => Left(failure), (_) => const Right(null));
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to delete schedule: ${e.toString()}'));
    }
  }
}

/// Parameters for DeleteSchedule use case
class DeleteScheduleParams extends Equatable {
  final String id;
  final bool cleanupReminders;

  const DeleteScheduleParams({required this.id, this.cleanupReminders = true});

  @override
  List<Object?> get props => [id, cleanupReminders];
}
