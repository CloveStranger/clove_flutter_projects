import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule.dart';
import '../entities/priority.dart';
import '../entities/repeat_rule.dart';
import '../../../reminder/domain/entities/reminder.dart';
import '../repositories/schedule_repository.dart';

/// Use case for adding a new schedule with validation
class AddSchedule implements UseCase<Schedule, AddScheduleParams> {
  final ScheduleRepository repository;

  const AddSchedule(this.repository);

  @override
  Future<Either<Failure, Schedule>> call(AddScheduleParams params) async {
    try {
      // Validate the schedule data
      final validationResult = _validateSchedule(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Create the schedule entity
      final schedule = Schedule.create(
        id: params.id,
        title: params.title,
        startTime: params.startTime,
        endTime: params.endTime,
        categoryId: params.categoryId,
        priority: params.priority,
        description: params.description,
        location: params.location,
        repeatRule: params.repeatRule,
        reminders: params.reminders,
        deviceId: params.deviceId,
      );

      // Check for conflicts if requested
      if (params.checkConflicts) {
        final conflictsResult = await repository.getConflictingSchedules(schedule.startTime, schedule.endTime);

        return conflictsResult.fold((failure) => Left(failure), (conflicts) {
          if (conflicts.isNotEmpty) {
            return Left(ConflictFailure('Schedule conflicts with ${conflicts.length} existing schedule(s)'));
          }

          // No conflicts, proceed with adding
          return repository.addSchedule(schedule);
        });
      }

      // Add without conflict checking
      return repository.addSchedule(schedule);
    } catch (e) {
      return Left(GeneralFailure('Failed to add schedule: ${e.toString()}'));
    }
  }

  /// Validate schedule parameters
  String? _validateSchedule(AddScheduleParams params) {
    if (params.title.trim().isEmpty) {
      return 'Schedule title cannot be empty';
    }

    if (params.categoryId.trim().isEmpty) {
      return 'Category ID cannot be empty';
    }

    if (params.endTime.isBefore(params.startTime)) {
      return 'End time cannot be before start time';
    }

    if (params.endTime.isAtSameMomentAs(params.startTime)) {
      return 'End time cannot be the same as start time';
    }

    // Validate title length
    if (params.title.length > 200) {
      return 'Schedule title cannot exceed 200 characters';
    }

    // Validate description length
    if (params.description != null && params.description!.length > 1000) {
      return 'Schedule description cannot exceed 1000 characters';
    }

    // Validate location length
    if (params.location != null && params.location!.length > 300) {
      return 'Schedule location cannot exceed 300 characters';
    }

    return null; // No validation errors
  }
}

/// Parameters for AddSchedule use case
class AddScheduleParams extends Equatable {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String categoryId;
  final Priority priority;
  final String? description;
  final String? location;
  final RepeatRule? repeatRule;
  final List<Reminder>? reminders;
  final String? deviceId;
  final bool checkConflicts;

  const AddScheduleParams({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.categoryId,
    required this.priority,
    this.description,
    this.location,
    this.repeatRule,
    this.reminders,
    this.deviceId,
    this.checkConflicts = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    startTime,
    endTime,
    categoryId,
    priority,
    description,
    location,
    repeatRule,
    reminders,
    deviceId,
    checkConflicts,
  ];
}
