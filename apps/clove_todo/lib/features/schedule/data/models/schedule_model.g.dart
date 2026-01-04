// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      scheduleId: json['scheduleId'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      categoryId: json['categoryId'] as String,
      priority: (json['priority'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      location: json['location'] as String?,
      repeatRuleJson: json['repeatRuleJson'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      deviceId: json['deviceId'] as String?,
      syncHash: json['syncHash'] as String?,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
      'categoryId': instance.categoryId,
      'priority': instance.priority,
      'repeatRuleJson': instance.repeatRuleJson,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deviceId': instance.deviceId,
      'syncHash': instance.syncHash,
    };
