import 'package:equatable/equatable.dart';
import 'reminder_type.dart';

/// Domain entity representing a reminder for a schedule item
class Reminder extends Equatable {
  final String id;
  final String scheduleId;
  final DateTime remindTime;
  final ReminderType type;
  final bool isTriggered;
  final int minutesBefore;
  final String? customMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reminder({
    required this.id,
    required this.scheduleId,
    required this.remindTime,
    required this.type,
    required this.minutesBefore,
    required this.createdAt,
    required this.updatedAt,
    this.isTriggered = false,
    this.customMessage,
  });

  /// Create a new Reminder with validation and time calculation
  factory Reminder.create({
    required String id,
    required String scheduleId,
    required DateTime scheduleStartTime,
    required int minutesBefore,
    required ReminderType type,
    String? customMessage,
  }) {
    // Validate required fields
    if (id.trim().isEmpty) {
      throw ArgumentError('Reminder ID cannot be empty');
    }
    if (scheduleId.trim().isEmpty) {
      throw ArgumentError('Schedule ID cannot be empty');
    }
    if (minutesBefore < 0) {
      throw ArgumentError('Minutes before cannot be negative');
    }

    // Calculate reminder time
    final remindTime = scheduleStartTime.subtract(Duration(minutes: minutesBefore));

    // Validate that reminder time is not in the past (with 1 minute tolerance)
    final now = DateTime.now();
    if (remindTime.isBefore(now.subtract(const Duration(minutes: 1)))) {
      throw ArgumentError('Reminder time cannot be in the past');
    }

    return Reminder(
      id: id,
      scheduleId: scheduleId,
      remindTime: remindTime,
      type: type,
      minutesBefore: minutesBefore,
      customMessage: customMessage?.trim(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a reminder from an existing template
  factory Reminder.fromTemplate({
    required String id,
    required String scheduleId,
    required DateTime scheduleStartTime,
    required ReminderTemplate template,
  }) {
    return Reminder.create(
      id: id,
      scheduleId: scheduleId,
      scheduleStartTime: scheduleStartTime,
      minutesBefore: template.minutesBefore,
      type: template.type,
      customMessage: template.customMessage,
    );
  }

  /// Calculate reminder time based on schedule start time and minutes before
  static DateTime calculateReminderTime(DateTime scheduleStartTime, int minutesBefore) {
    if (minutesBefore < 0) {
      throw ArgumentError('Minutes before cannot be negative');
    }
    return scheduleStartTime.subtract(Duration(minutes: minutesBefore));
  }

  /// Create a copy of this reminder with updated fields
  Reminder copyWith({
    String? id,
    String? scheduleId,
    DateTime? remindTime,
    ReminderType? type,
    bool? isTriggered,
    int? minutesBefore,
    String? customMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      remindTime: remindTime ?? this.remindTime,
      type: type ?? this.type,
      isTriggered: isTriggered ?? this.isTriggered,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      customMessage: customMessage ?? this.customMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Mark this reminder as triggered
  Reminder markAsTriggered() {
    return copyWith(isTriggered: true);
  }

  /// Check if this reminder is due (should be triggered)
  bool isDue([DateTime? currentTime]) {
    final now = currentTime ?? DateTime.now();
    return !isTriggered && now.isAfter(remindTime);
  }

  /// Check if this reminder is upcoming (within the next hour)
  bool isUpcoming([DateTime? currentTime]) {
    final now = currentTime ?? DateTime.now();
    final oneHourFromNow = now.add(const Duration(hours: 1));
    return !isTriggered && remindTime.isAfter(now) && remindTime.isBefore(oneHourFromNow);
  }

  /// Get the time remaining until this reminder should trigger
  Duration? getTimeUntilTrigger([DateTime? currentTime]) {
    final now = currentTime ?? DateTime.now();
    if (isTriggered || remindTime.isBefore(now)) {
      return null;
    }
    return remindTime.difference(now);
  }

  /// Validate that the reminder time calculation is accurate
  bool hasAccurateReminderTime(DateTime scheduleStartTime) {
    final expectedTime = scheduleStartTime.subtract(Duration(minutes: minutesBefore));
    return remindTime.isAtSameMomentAs(expectedTime);
  }

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    remindTime,
    type,
    isTriggered,
    minutesBefore,
    customMessage,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Reminder(id: $id, scheduleId: $scheduleId, remindTime: $remindTime, type: $type, minutesBefore: $minutesBefore, isTriggered: $isTriggered)';
  }
}

/// Template for creating reminders with predefined settings
class ReminderTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final int minutesBefore;
  final ReminderType type;
  final String? customMessage;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.minutesBefore,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.customMessage,
    this.isDefault = false,
  });

  /// Create a new ReminderTemplate with validation
  factory ReminderTemplate.create({
    required String id,
    required String name,
    required String description,
    required int minutesBefore,
    required ReminderType type,
    String? customMessage,
    bool isDefault = false,
  }) {
    // Validate required fields
    if (id.trim().isEmpty) {
      throw ArgumentError('Template ID cannot be empty');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Template name cannot be empty');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Template description cannot be empty');
    }
    if (minutesBefore < 0) {
      throw ArgumentError('Minutes before cannot be negative');
    }

    final now = DateTime.now();
    return ReminderTemplate(
      id: id,
      name: name.trim(),
      description: description.trim(),
      minutesBefore: minutesBefore,
      type: type,
      customMessage: customMessage?.trim(),
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create default reminder templates
  static List<ReminderTemplate> createDefaults() {
    final now = DateTime.now();
    return [
      ReminderTemplate(
        id: 'default_meeting',
        name: 'Meeting Reminder',
        description: '15 minutes before meetings',
        minutesBefore: 15,
        type: ReminderType.notification,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      ReminderTemplate(
        id: 'default_flight',
        name: 'Flight Reminder',
        description: '2 hours before flights',
        minutesBefore: 120,
        type: ReminderType.notification,
        customMessage: 'Time to head to the airport!',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      ReminderTemplate(
        id: 'default_birthday',
        name: 'Birthday Reminder',
        description: '1 day before birthdays',
        minutesBefore: 1440, // 24 hours
        type: ReminderType.notification,
        customMessage: 'Don\'t forget to wish them happy birthday!',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      ReminderTemplate(
        id: 'default_deadline',
        name: 'Deadline Reminder',
        description: '1 hour before deadlines',
        minutesBefore: 60,
        type: ReminderType.notification,
        customMessage: 'Deadline approaching!',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Create a copy of this template with updated fields
  ReminderTemplate copyWith({
    String? id,
    String? name,
    String? description,
    int? minutesBefore,
    ReminderType? type,
    String? customMessage,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      type: type ?? this.type,
      customMessage: customMessage ?? this.customMessage,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Apply this template to create a reminder for a schedule
  Reminder applyToSchedule({
    required String reminderId,
    required String scheduleId,
    required DateTime scheduleStartTime,
  }) {
    return Reminder.fromTemplate(
      id: reminderId,
      scheduleId: scheduleId,
      scheduleStartTime: scheduleStartTime,
      template: this,
    );
  }

  /// Check if the template configuration is consistent with a reminder
  bool isConsistentWith(Reminder reminder) {
    return reminder.minutesBefore == minutesBefore && reminder.type == type && reminder.customMessage == customMessage;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    minutesBefore,
    type,
    customMessage,
    isDefault,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'ReminderTemplate(id: $id, name: $name, minutesBefore: $minutesBefore, type: $type, isDefault: $isDefault)';
  }
}
