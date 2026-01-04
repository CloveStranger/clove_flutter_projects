import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule.dart';
import '../entities/priority.dart';
import '../entities/repeat_rule.dart';
import '../../../reminder/domain/entities/reminder.dart';
import '../repositories/schedule_repository.dart';

/// Use case for updating an existing schedule with timestamp handling
class UpdateSchedule implements UseCase<Schedule, UpdateScheduleParams> {
  final ScheduleRepository repository;

  const UpdateSchedule(this.repository);

  @override
  Future<Either<Failure, Schedule>> call(UpdateScheduleParams params) async {
    try {
      // First, get the existing schedule
      final existingResult = await repository.getScheduleById(params.id);

      return existingResult.fold((failure) => Left(failure), (existingSchedule) async {
        // Validate the update parameters
        final validationResult = _validateUpdate(params, existingSchedule);
        if (validationResult != null) {
          return Left(ValidationFailure(validationResult));
        }

        // Create updated schedule with new timestamp
        final updatedSchedule = existingSchedule.copyWith(
          title: params.title,
          description: params.description,
          startTime: params.startTime,
          endTime: params.endTime,
          location: params.location,
          categoryId: params.categoryId,
          priority: params.priority,
          repeatRule: params.repeatRule,
          reminders: params.reminders,
          isCompleted: params.isCompleted,
          updatedAt: DateTime.now(), // Ensure timestamp is updated
        );

        // Check for conflicts if time changed and requested
        if (params.checkConflicts && _timeChanged(existingSchedule, updatedSchedule)) {
          final conflictsResult = await repository.getConflictingSchedules(
            updatedSchedule.startTime,
            updatedSchedule.endTime,
            excludeScheduleId: updatedSchedule.id,
          );

          return conflictsResult.fold((failure) => Left(failure), (conflicts) {
            if (conflicts.isNotEmpty) {
              return Left(ConflictFailure('Updated schedule conflicts with ${conflicts.length} existing schedule(s)'));
            }

            // No conflicts, proceed with update
            return repository.updateSchedule(updatedSchedule);
          });
        }

        // Update without conflict checking
        return repository.updateSchedule(updatedSchedule);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to update schedule: ${e.toString()}'));
    }
  }

  /// Validate update parameters
  String? _validateUpdate(UpdateScheduleParams params, Schedule existingSchedule) {
    if (params.title != null && params.title!.trim().isEmpty) {
      return 'Schedule title cannot be empty';
    }

    if (params.categoryId != null && params.categoryId!.trim().isEmpty) {
      return 'Category ID cannot be empty';
    }

    final startTime = params.startTime ?? existingSchedule.startTime;
    final endTime = params.endTime ?? existingSchedule.endTime;

    if (endTime.isBefore(startTime)) {
      return 'End time cannot be before start time';
    }

    if (endTime.isAtSameMomentAs(startTime)) {
      return 'End time cannot be the same as start time';
    }

    // Validate title length
    final title = params.title ?? existingSchedule.title;
    if (title.length > 200) {
      return 'Schedule title cannot exceed 200 characters';
    }

    // Validate description length
    final description = params.description ?? existingSchedule.description;
    if (description != null && description.length > 1000) {
      return 'Schedule description cannot exceed 1000 characters';
    }

    // Validate location length
    final location = params.location ?? existingSchedule.location;
    if (location != null && location.length > 300) {
      return 'Schedule location cannot exceed 300 characters';
    }

    return null; // No validation errors
  }

  /// Check if the time has changed
  bool _timeChanged(Schedule existing, Schedule updated) {
    return !existing.startTime.isAtSameMomentAs(updated.startTime) ||
        !existing.endTime.isAtSameMomentAs(updated.endTime);
  }
}

/// Parameters for UpdateSchedule use case
class UpdateScheduleParams extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final String? categoryId;
  final Priority? priority;
  final RepeatRule? repeatRule;
  final List<Reminder>? reminders;
  final bool? isCompleted;
  final bool checkConflicts;

  const UpdateScheduleParams({
    required this.id,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.categoryId,
    this.priority,
    this.repeatRule,
    this.reminders,
    this.isCompleted,
    this.checkConflicts = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startTime,
    endTime,
    location,
    categoryId,
    priority,
    repeatRule,
    reminders,
    isCompleted,
    checkConflicts,
  ];
}
