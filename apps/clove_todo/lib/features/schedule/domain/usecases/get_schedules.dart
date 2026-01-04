import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule.dart';
import '../entities/priority.dart';
import '../repositories/schedule_repository.dart';

/// Use case for retrieving schedules with various filtering options
class GetSchedules implements UseCase<List<Schedule>, GetSchedulesParams> {
  final ScheduleRepository repository;

  const GetSchedules(this.repository);

  @override
  Future<Either<Failure, List<Schedule>>> call(GetSchedulesParams params) async {
    try {
      // Determine which method to call based on parameters
      if (params.dateRange != null) {
        return repository.getSchedulesByDateRange(params.dateRange!.start, params.dateRange!.end);
      }

      if (params.categoryId != null) {
        return repository.getSchedulesByCategory(params.categoryId!);
      }

      if (params.priority != null) {
        return repository.getSchedulesByPriority(params.priority!);
      }

      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        return repository.searchSchedules(params.searchQuery!);
      }

      switch (params.filterType) {
        case ScheduleFilterType.upcoming:
          return repository.getUpcomingSchedules();
        case ScheduleFilterType.overdue:
          return repository.getOverdueSchedules();
        case ScheduleFilterType.active:
          return repository.getActiveSchedules();
        case ScheduleFilterType.completed:
          return repository.getCompletedSchedules();
        case ScheduleFilterType.all:
          return repository.getSchedules();
      }
    } catch (e) {
      return Left(GeneralFailure('Failed to get schedules: ${e.toString()}'));
    }
  }
}

/// Use case for retrieving a single schedule by ID
class GetScheduleById implements UseCase<Schedule, GetScheduleByIdParams> {
  final ScheduleRepository repository;

  const GetScheduleById(this.repository);

  @override
  Future<Either<Failure, Schedule>> call(GetScheduleByIdParams params) async {
    try {
      if (params.id.trim().isEmpty) {
        return Left(ValidationFailure('Schedule ID cannot be empty'));
      }

      return repository.getScheduleById(params.id);
    } catch (e) {
      return Left(GeneralFailure('Failed to get schedule: ${e.toString()}'));
    }
  }
}

/// Filter types for schedule retrieval
enum ScheduleFilterType { all, upcoming, overdue, active, completed }

/// Date range for filtering schedules
class DateRange extends Equatable {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  /// Create a date range for today
  factory DateRange.today() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return DateRange(start: startOfDay, end: endOfDay);
  }

  /// Create a date range for this week
  factory DateRange.thisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return DateRange(start: startOfWeek, end: endOfWeek);
  }

  /// Create a date range for this month
  factory DateRange.thisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return DateRange(start: startOfMonth, end: endOfMonth);
  }

  @override
  List<Object?> get props => [start, end];
}

/// Parameters for GetSchedules use case
class GetSchedulesParams extends Equatable {
  final ScheduleFilterType filterType;
  final DateRange? dateRange;
  final String? categoryId;
  final Priority? priority;
  final String? searchQuery;

  const GetSchedulesParams({
    this.filterType = ScheduleFilterType.all,
    this.dateRange,
    this.categoryId,
    this.priority,
    this.searchQuery,
  });

  /// Create parameters for all schedules
  const GetSchedulesParams.all() : this(filterType: ScheduleFilterType.all);

  /// Create parameters for upcoming schedules
  const GetSchedulesParams.upcoming() : this(filterType: ScheduleFilterType.upcoming);

  /// Create parameters for overdue schedules
  const GetSchedulesParams.overdue() : this(filterType: ScheduleFilterType.overdue);

  /// Create parameters for active schedules
  const GetSchedulesParams.active() : this(filterType: ScheduleFilterType.active);

  /// Create parameters for completed schedules
  const GetSchedulesParams.completed() : this(filterType: ScheduleFilterType.completed);

  /// Create parameters for schedules in date range
  const GetSchedulesParams.dateRange(DateRange dateRange) : this(dateRange: dateRange);

  /// Create parameters for schedules by category
  const GetSchedulesParams.category(String categoryId) : this(categoryId: categoryId);

  /// Create parameters for schedules by priority
  const GetSchedulesParams.priority(Priority priority) : this(priority: priority);

  /// Create parameters for search
  const GetSchedulesParams.search(String query) : this(searchQuery: query);

  @override
  List<Object?> get props => [filterType, dateRange, categoryId, priority, searchQuery];
}

/// Parameters for GetScheduleById use case
class GetScheduleByIdParams extends Equatable {
  final String id;

  const GetScheduleByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
