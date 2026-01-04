import 'package:equatable/equatable.dart';
import 'repeat_type.dart';

/// Value object representing a repeat rule for schedule items
class RepeatRule extends Equatable {
  final RepeatType type;
  final int interval;
  final List<int>? daysOfWeek; // 1-7 (Monday-Sunday)
  final DateTime? endDate;
  final int? occurrences;

  const RepeatRule({required this.type, required this.interval, this.daysOfWeek, this.endDate, this.occurrences});

  /// Create a RepeatRule with validation
  factory RepeatRule.create({
    required RepeatType type,
    required int interval,
    List<int>? daysOfWeek,
    DateTime? endDate,
    int? occurrences,
  }) {
    // Validate interval
    if (interval <= 0) {
      throw ArgumentError('Interval must be positive');
    }

    // Validate days of week
    if (daysOfWeek != null) {
      if (daysOfWeek.isEmpty) {
        throw ArgumentError('Days of week cannot be empty when provided');
      }
      for (final day in daysOfWeek) {
        if (day < 1 || day > 7) {
          throw ArgumentError('Days of week must be between 1 and 7');
        }
      }
      // Remove duplicates and sort
      daysOfWeek = daysOfWeek.toSet().toList()..sort();
    }

    // Validate occurrences
    if (occurrences != null && occurrences <= 0) {
      throw ArgumentError('Occurrences must be positive');
    }

    // Validate end date
    if (endDate != null && endDate.isBefore(DateTime.now())) {
      throw ArgumentError('End date cannot be in the past');
    }

    // Type-specific validations
    switch (type) {
      case RepeatType.none:
        if (interval != 1 || daysOfWeek != null || endDate != null || occurrences != null) {
          throw ArgumentError('No repeat type should not have additional parameters');
        }
        break;
      case RepeatType.weekly:
        if (daysOfWeek == null || daysOfWeek.isEmpty) {
          throw ArgumentError('Weekly repeat must specify days of week');
        }
        break;
      case RepeatType.daily:
      case RepeatType.monthly:
      case RepeatType.yearly:
      case RepeatType.custom:
        // These types are valid with the basic validations above
        break;
    }

    return RepeatRule(
      type: type,
      interval: interval,
      daysOfWeek: daysOfWeek,
      endDate: endDate,
      occurrences: occurrences,
    );
  }

  /// Create a simple daily repeat rule
  factory RepeatRule.daily({int interval = 1, DateTime? endDate, int? occurrences}) {
    return RepeatRule.create(type: RepeatType.daily, interval: interval, endDate: endDate, occurrences: occurrences);
  }

  /// Create a weekly repeat rule
  factory RepeatRule.weekly({required List<int> daysOfWeek, int interval = 1, DateTime? endDate, int? occurrences}) {
    return RepeatRule.create(
      type: RepeatType.weekly,
      interval: interval,
      daysOfWeek: daysOfWeek,
      endDate: endDate,
      occurrences: occurrences,
    );
  }

  /// Create a monthly repeat rule
  factory RepeatRule.monthly({int interval = 1, DateTime? endDate, int? occurrences}) {
    return RepeatRule.create(type: RepeatType.monthly, interval: interval, endDate: endDate, occurrences: occurrences);
  }

  /// Create a yearly repeat rule
  factory RepeatRule.yearly({int interval = 1, DateTime? endDate, int? occurrences}) {
    return RepeatRule.create(type: RepeatType.yearly, interval: interval, endDate: endDate, occurrences: occurrences);
  }

  /// Create a no-repeat rule
  factory RepeatRule.none() {
    return const RepeatRule(type: RepeatType.none, interval: 1);
  }

  /// Check if this rule has an end condition
  bool get hasEndCondition => endDate != null || occurrences != null;

  /// Check if the rule should end after a specific date
  bool shouldEndAfter(DateTime date) {
    if (endDate != null && date.isAfter(endDate!)) {
      return true;
    }
    return false;
  }

  /// Calculate the next occurrence after the given date
  DateTime? getNextOccurrence(DateTime after) {
    if (type == RepeatType.none) {
      return null;
    }

    DateTime next = after;

    switch (type) {
      case RepeatType.daily:
        next = after.add(Duration(days: interval));
        break;
      case RepeatType.weekly:
        // Find next occurrence based on days of week
        if (daysOfWeek != null && daysOfWeek!.isNotEmpty) {
          int currentWeekday = after.weekday;
          int? nextDay = daysOfWeek!.firstWhere((day) => day > currentWeekday, orElse: () => daysOfWeek!.first);

          if (nextDay > currentWeekday) {
            // Same week
            next = after.add(Duration(days: nextDay - currentWeekday));
          } else {
            // Next week(s)
            int daysToAdd = (7 * interval) - currentWeekday + nextDay;
            next = after.add(Duration(days: daysToAdd));
          }
        }
        break;
      case RepeatType.monthly:
        next = DateTime(after.year, after.month + interval, after.day, after.hour, after.minute);
        break;
      case RepeatType.yearly:
        next = DateTime(after.year + interval, after.month, after.day, after.hour, after.minute);
        break;
      case RepeatType.custom:
        // For custom rules, default to daily for now
        next = after.add(Duration(days: interval));
        break;
      case RepeatType.none:
        return null;
    }

    // Check if we've exceeded the end conditions
    if (shouldEndAfter(next)) {
      return null;
    }

    return next;
  }

  @override
  List<Object?> get props => [type, interval, daysOfWeek, endDate, occurrences];

  @override
  String toString() {
    return 'RepeatRule(type: $type, interval: $interval, daysOfWeek: $daysOfWeek, endDate: $endDate, occurrences: $occurrences)';
  }
}
