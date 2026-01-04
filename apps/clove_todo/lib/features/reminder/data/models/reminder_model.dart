import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/entities/reminder_type.dart';
import '../../../schedule/data/models/schedule_model.dart';

part 'reminder_model.g.dart';

/// ObjectBox model for Reminder entity
@Entity()
@JsonSerializable()
class ReminderModel {
  @Id()
  int id = 0;

  @Unique()
  String reminderId;

  @Property(type: PropertyType.date)
  DateTime remindTime;

  @Property(type: PropertyType.byte)
  int type; // ReminderType enum as int

  bool isTriggered;
  int minutesBefore;
  String? customMessage;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  /// Relationship to schedule
  final schedule = ToOne<ScheduleModel>();

  ReminderModel({
    required this.reminderId,
    required this.remindTime,
    required this.type,
    required this.minutesBefore,
    required this.createdAt,
    required this.updatedAt,
    this.isTriggered = false,
    this.customMessage,
  });

  /// Convert from domain entity to model
  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      reminderId: reminder.id,
      remindTime: reminder.remindTime,
      type: reminder.type.index,
      isTriggered: reminder.isTriggered,
      minutesBefore: reminder.minutesBefore,
      customMessage: reminder.customMessage,
      createdAt: reminder.createdAt,
      updatedAt: reminder.updatedAt,
    );
  }

  /// Convert from model to domain entity
  Reminder toEntity() {
    return Reminder(
      id: reminderId,
      scheduleId: schedule.target?.scheduleId ?? '',
      remindTime: remindTime,
      type: ReminderType.values[type],
      isTriggered: isTriggered,
      minutesBefore: minutesBefore,
      customMessage: customMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// JSON serialization for sync
  factory ReminderModel.fromJson(Map<String, dynamic> json) => _$ReminderModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);

  @override
  String toString() {
    return 'ReminderModel(id: $id, reminderId: $reminderId, remindTime: $remindTime, type: $type)';
  }
}
