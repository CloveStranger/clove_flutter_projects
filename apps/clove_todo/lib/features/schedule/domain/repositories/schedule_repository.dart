import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/schedule.dart';
import '../entities/priority.dart';

/// Repository interface for schedule management operations
abstract class ScheduleRepository {
  /// Get all schedules
  Future<Either<Failure, List<Schedule>>> getSchedules();

  /// Get a specific schedule by ID
  Future<Either<Failure, Schedule>> getScheduleById(String id);

  /// Add a new schedule
  Future<Either<Failure, Schedule>> addSchedule(Schedule schedule);

  /// Update an existing schedule
  Future<Either<Failure, Schedule>> updateSchedule(Schedule schedule);

  /// Delete a schedule by ID
  Future<Either<Failure, void>> deleteSchedule(String id);

  /// Get schedules within a specific date range
  Future<Either<Failure, List<Schedule>>> getSchedulesByDateRange(DateTime startDate, DateTime endDate);

  /// Search schedules by query (title, description, location)
  Future<Either<Failure, List<Schedule>>> searchSchedules(String query);

  /// Get schedules by category
  Future<Either<Failure, List<Schedule>>> getSchedulesByCategory(String categoryId);

  /// Get schedules by priority
  Future<Either<Failure, List<Schedule>>> getSchedulesByPriority(Priority priority);

  /// Get upcoming schedules (not completed, start time in future)
  Future<Either<Failure, List<Schedule>>> getUpcomingSchedules();

  /// Get overdue schedules (not completed, end time in past)
  Future<Either<Failure, List<Schedule>>> getOverdueSchedules();

  /// Get active schedules (currently happening)
  Future<Either<Failure, List<Schedule>>> getActiveSchedules();

  /// Get completed schedules
  Future<Either<Failure, List<Schedule>>> getCompletedSchedules();

  /// Mark a schedule as completed
  Future<Either<Failure, Schedule>> markScheduleAsCompleted(String id);

  /// Mark a schedule as not completed
  Future<Either<Failure, Schedule>> markScheduleAsNotCompleted(String id);

  /// Get schedules that conflict with a given time range
  Future<Either<Failure, List<Schedule>>> getConflictingSchedules(
    DateTime startTime,
    DateTime endTime, {
    String? excludeScheduleId,
  });

  /// Batch operations for sync
  Future<Either<Failure, List<Schedule>>> addSchedules(List<Schedule> schedules);
  Future<Either<Failure, List<Schedule>>> updateSchedules(List<Schedule> schedules);
  Future<Either<Failure, void>> deleteSchedules(List<String> ids);

  /// Get schedules modified after a specific timestamp (for sync)
  Future<Either<Failure, List<Schedule>>> getSchedulesModifiedAfter(DateTime timestamp);

  /// Get total count of schedules
  Future<Either<Failure, int>> getScheduleCount();

  /// Get schedule statistics
  Future<Either<Failure, Map<String, int>>> getScheduleStatistics();
}
