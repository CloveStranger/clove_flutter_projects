import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case for applying a reminder template to create a reminder for a schedule
class ApplyReminderTemplate implements UseCase<Reminder, ApplyReminderTemplateParams> {
  final ReminderRepository repository;

  const ApplyReminderTemplate(this.repository);

  @override
  Future<Either<Failure, Reminder>> call(ApplyReminderTemplateParams params) async {
    try {
      // Validate parameters
      final validationResult = _validateParams(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Use the repository method to apply the template
      return repository.applyReminderTemplate(
        templateId: params.templateId,
        scheduleId: params.scheduleId,
        scheduleStartTime: params.scheduleStartTime,
      );
    } catch (e) {
      return Left(GeneralFailure('Failed to apply reminder template: ${e.toString()}'));
    }
  }

  /// Validate parameters
  String? _validateParams(ApplyReminderTemplateParams params) {
    if (params.templateId.trim().isEmpty) {
      return 'Template ID cannot be empty';
    }

    if (params.scheduleId.trim().isEmpty) {
      return 'Schedule ID cannot be empty';
    }

    // Validate that schedule start time is not in the past (with 1 minute tolerance)
    final now = DateTime.now();
    if (params.scheduleStartTime.isBefore(now.subtract(const Duration(minutes: 1)))) {
      return 'Schedule start time cannot be in the past';
    }

    return null; // No validation errors
  }
}

/// Parameters for ApplyReminderTemplate use case
class ApplyReminderTemplateParams extends Equatable {
  final String templateId;
  final String scheduleId;
  final DateTime scheduleStartTime;

  const ApplyReminderTemplateParams({
    required this.templateId,
    required this.scheduleId,
    required this.scheduleStartTime,
  });

  @override
  List<Object?> get props => [templateId, scheduleId, scheduleStartTime];
}
