import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/schedule.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/repeat_rule.dart';
import '../../domain/entities/repeat_type.dart';
import '../../../reminder/data/models/reminder_model.dart';
import '../../../reminder/domain/entities/reminder.dart';

part 'schedule_model.g.dart';

/// ObjectBox model for Schedule entity
@Entity()
@JsonSerializable()
class ScheduleModel {
  @Id()
  int id = 0;

  @Unique()
  String scheduleId;
  String title;
  String? description;

  @Property(type: PropertyType.date)
  DateTime startTime;

  @Property(type: PropertyType.date)
  DateTime endTime;

  String? location;
  String categoryId;

  @Property(type: PropertyType.byte)
  int priority; // Priority enum as int

  String? repeatRuleJson; // RepeatRule serialized as JSON
  bool isCompleted;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  String? deviceId;
  String? syncHash;

  /// Relationship to reminders
  @Backlink('schedule')
  final reminders = ToMany<ReminderModel>();

  ScheduleModel({
    required this.scheduleId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.categoryId,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.location,
    this.repeatRuleJson,
    this.isCompleted = false,
    this.deviceId,
    this.syncHash,
  });

  /// Convert from domain entity to model
  factory ScheduleModel.fromEntity(Schedule schedule) {
    final model = ScheduleModel(
      scheduleId: schedule.id,
      title: schedule.title,
      description: schedule.description,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      location: schedule.location,
      categoryId: schedule.categoryId,
      priority: schedule.priority.index,
      repeatRuleJson: schedule.repeatRule != null ? jsonEncode(_repeatRuleToJson(schedule.repeatRule!)) : null,
      isCompleted: schedule.isCompleted,
      createdAt: schedule.createdAt,
      updatedAt: schedule.updatedAt,
      deviceId: schedule.deviceId,
      syncHash: schedule.syncHash,
    );

    // Add reminders
    for (final reminder in schedule.reminders) {
      model.reminders.add(ReminderModel.fromEntity(reminder));
    }

    return model;
  }

  /// Convert from model to domain entity
  Schedule toEntity() {
    RepeatRule? repeatRule;
    if (repeatRuleJson != null) {
      try {
        final json = jsonDecode(repeatRuleJson!) as Map<String, dynamic>;
        repeatRule = _repeatRuleFromJson(json);
      } catch (e) {
        // If parsing fails, set to null
        repeatRule = null;
      }
    }

    return Schedule(
      id: scheduleId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      categoryId: categoryId,
      priority: Priority.values[priority],
      repeatRule: repeatRule,
      reminders: reminders.map((r) => r.toEntity()).toList(),
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deviceId: deviceId,
      syncHash: syncHash,
    );
  }

  /// Convert RepeatRule to JSON map
  static Map<String, dynamic> _repeatRuleToJson(RepeatRule repeatRule) {
    return {
      'type': repeatRule.type.name,
      'interval': repeatRule.interval,
      'daysOfWeek': repeatRule.daysOfWeek,
      'endDate': repeatRule.endDate?.toIso8601String(),
      'occurrences': repeatRule.occurrences,
    };
  }

  /// Convert JSON map to RepeatRule
  static RepeatRule _repeatRuleFromJson(Map<String, dynamic> json) {
    return RepeatRule.create(
      type: RepeatType.fromString(json['type'] as String),
      interval: json['interval'] as int,
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)?.cast<int>(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      occurrences: json['occurrences'] as int?,
    );
  }

  /// JSON serialization for sync
  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  @override
  String toString() {
    return 'ScheduleModel(id: $id, scheduleId: $scheduleId, title: $title, startTime: $startTime, endTime: $endTime)';
  }
}
