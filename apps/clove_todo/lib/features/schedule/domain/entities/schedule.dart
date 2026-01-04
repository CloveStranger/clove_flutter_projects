import 'package:equatable/equatable.dart';
import 'priority.dart';
import 'repeat_rule.dart';
import 'repeat_type.dart';
import '../../../reminder/domain/entities/reminder.dart';

/// Domain entity representing a schedule item
class Schedule extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String categoryId;
  final Priority priority;
  final RepeatRule? repeatRule;
  final List<Reminder> reminders;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deviceId;
  final String? syncHash;

  const Schedule({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.categoryId,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.location,
    this.repeatRule,
    this.reminders = const [],
    this.isCompleted = false,
    this.deviceId,
    this.syncHash,
  });

  /// Create a new Schedule with validation
  factory Schedule.create({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required String categoryId,
    required Priority priority,
    String? description,
    String? location,
    RepeatRule? repeatRule,
    List<Reminder>? reminders,
    bool isCompleted = false,
    String? deviceId,
    String? syncHash,
  }) {
    // Validate required fields
    if (id.trim().isEmpty) {
      throw ArgumentError('Schedule ID cannot be empty');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('Schedule title cannot be empty');
    }
    if (categoryId.trim().isEmpty) {
      throw ArgumentError('Category ID cannot be empty');
    }

    // Validate time constraints
    if (endTime.isBefore(startTime)) {
      throw ArgumentError('End time cannot be before start time');
    }
    if (endTime.isAtSameMomentAs(startTime)) {
      throw ArgumentError('End time cannot be the same as start time');
    }

    final now = DateTime.now();
    return Schedule(
      id: id,
      title: title.trim(),
      description: description?.trim(),
      startTime: startTime,
      endTime: endTime,
      location: location?.trim(),
      categoryId: categoryId,
      priority: priority,
      repeatRule: repeatRule,
      reminders: reminders ?? [],
      isCompleted: isCompleted,
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
      syncHash: syncHash,
    );
  }

  /// Create a copy of this schedule with updated fields
  Schedule copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? categoryId,
    Priority? priority,
    RepeatRule? repeatRule,
    List<Reminder>? reminders,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
    String? syncHash,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      repeatRule: repeatRule ?? this.repeatRule,
      reminders: reminders ?? this.reminders,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      deviceId: deviceId ?? this.deviceId,
      syncHash: syncHash ?? this.syncHash,
    );
  }

  /// Get the duration of this schedule
  Duration get duration => endTime.difference(startTime);

  /// Check if this schedule is currently active
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime) && !isCompleted;
  }

  /// Check if this schedule is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    return now.isBefore(startTime) && !isCompleted;
  }

  /// Check if this schedule is overdue
  bool get isOverdue {
    final now = DateTime.now();
    return now.isAfter(endTime) && !isCompleted;
  }

  /// Check if this schedule has a repeat rule
  bool get isRepeating => repeatRule != null && repeatRule!.type != RepeatType.none;

  /// Check if this schedule has reminders
  bool get hasReminders => reminders.isNotEmpty;

  /// Get the next occurrence of this schedule (if repeating)
  DateTime? getNextOccurrence() {
    if (!isRepeating) return null;
    return repeatRule!.getNextOccurrence(endTime);
  }

  /// Check if this schedule conflicts with another schedule
  bool conflictsWith(Schedule other) {
    // No conflict if either is completed
    if (isCompleted || other.isCompleted) return false;

    // Check for time overlap
    return startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime);
  }

  /// Validate that all required fields are present and valid
  bool hasAllRequiredFields() {
    return id.isNotEmpty && title.isNotEmpty && categoryId.isNotEmpty && endTime.isAfter(startTime);
  }

  /// Validate that timestamps are properly set
  bool hasValidTimestamps() {
    return createdAt.isBefore(updatedAt) || createdAt.isAtSameMomentAs(updatedAt);
  }

  /// Check if this schedule contains all the input data from creation
  bool containsAllInputData(Map<String, dynamic> inputData) {
    return title == inputData['title'] &&
        description == inputData['description'] &&
        startTime == inputData['startTime'] &&
        endTime == inputData['endTime'] &&
        location == inputData['location'] &&
        categoryId == inputData['categoryId'] &&
        priority == inputData['priority'];
  }

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
    createdAt,
    updatedAt,
    deviceId,
    syncHash,
  ];

  @override
  String toString() {
    return 'Schedule(id: $id, title: $title, startTime: $startTime, endTime: $endTime, priority: $priority, isCompleted: $isCompleted)';
  }
}
