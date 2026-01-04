import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/reminder_repository.dart';

/// Use case for canceling (deleting) a reminder
class CancelReminder implements UseCase<void, CancelReminderParams> {
  final ReminderRepository repository;

  const CancelReminder(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelReminderParams params) async {
    try {
      // Validate the reminder ID
      if (params.id.trim().isEmpty) {
        return Left(ValidationFailure('Reminder ID cannot be empty'));
      }

      // Check if the reminder exists before attempting to cancel
      final reminderResult = await repository.getReminderById(params.id);

      return reminderResult.fold((failure) => Left(failure), (reminder) async {
        // If reminder is already triggered and we're not forcing cancellation, return error
        if (reminder.isTriggered && !params.force) {
          return Left(ConflictFailure('Cannot cancel a reminder that has already been triggered'));
        }

        // Cancel the reminder
        return repository.cancelReminder(params.id);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to cancel reminder: ${e.toString()}'));
    }
  }
}

/// Parameters for CancelReminder use case
class CancelReminderParams extends Equatable {
  final String id;
  final bool force; // Force cancellation even if already triggered

  const CancelReminderParams({required this.id, this.force = false});

  @override
  List<Object?> get props => [id, force];
}
