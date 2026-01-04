import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/entities.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case for adding a new reminder with time calculation and validation
class AddReminder implements UseCase<Reminder, AddReminderParams> {
  final ReminderRepository repository;

  const AddReminder(this.repository);

  @override
  Future<Either<Failure, Reminder>> call(AddReminderParams params) async {
    try {
      // Validate the reminder parameters
      final validationResult = _validateReminder(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Create the reminder entity with time calculation
      final reminder = Reminder.create(
        id: params.id,
        scheduleId: params.scheduleId,
        scheduleStartTime: params.scheduleStartTime,
        minutesBefore: params.minutesBefore,
        type: params.type,
        customMessage: params.customMessage,
      );

      // Add the reminder through repository
      return repository.addReminder(reminder);
    } catch (e) {
      return Left(GeneralFailure('Failed to add reminder: ${e.toString()}'));
    }
  }

  /// Validate reminder parameters
  String? _validateReminder(AddReminderParams params) {
    if (params.id.trim().isEmpty) {
      return 'Reminder ID cannot be empty';
    }

    if (params.scheduleId.trim().isEmpty) {
      return 'Schedule ID cannot be empty';
    }

    if (params.minutesBefore < 0) {
      return 'Minutes before cannot be negative';
    }

    // Validate that the reminder time is not too far in the past
    final reminderTime = params.scheduleStartTime.subtract(Duration(minutes: params.minutesBefore));
    final now = DateTime.now();
    if (reminderTime.isBefore(now.subtract(const Duration(minutes: 1)))) {
      return 'Reminder time cannot be in the past';
    }

    // Validate custom message length
    if (params.customMessage != null && params.customMessage!.length > 500) {
      return 'Custom message cannot exceed 500 characters';
    }

    return null; // No validation errors
  }
}

/// Parameters for AddReminder use case
class AddReminderParams extends Equatable {
  final String id;
  final String scheduleId;
  final DateTime scheduleStartTime;
  final int minutesBefore;
  final ReminderType type;
  final String? customMessage;

  const AddReminderParams({
    required this.id,
    required this.scheduleId,
    required this.scheduleStartTime,
    required this.minutesBefore,
    required this.type,
    this.customMessage,
  });

  @override
  List<Object?> get props => [id, scheduleId, scheduleStartTime, minutesBefore, type, customMessage];
}
