// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) =>
    ReminderModel(
      reminderId: json['reminderId'] as String,
      remindTime: DateTime.parse(json['remindTime'] as String),
      type: (json['type'] as num).toInt(),
      minutesBefore: (json['minutesBefore'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isTriggered: json['isTriggered'] as bool? ?? false,
      customMessage: json['customMessage'] as String?,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$ReminderModelToJson(ReminderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reminderId': instance.reminderId,
      'remindTime': instance.remindTime.toIso8601String(),
      'type': instance.type,
      'isTriggered': instance.isTriggered,
      'minutesBefore': instance.minutesBefore,
      'customMessage': instance.customMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
