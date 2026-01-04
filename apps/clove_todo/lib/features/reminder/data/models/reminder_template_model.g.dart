// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderTemplateModel _$ReminderTemplateModelFromJson(
        Map<String, dynamic> json) =>
    ReminderTemplateModel(
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      minutesBefore: (json['minutesBefore'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      customMessage: json['customMessage'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$ReminderTemplateModelToJson(
        ReminderTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'templateId': instance.templateId,
      'name': instance.name,
      'description': instance.description,
      'minutesBefore': instance.minutesBefore,
      'type': instance.type,
      'customMessage': instance.customMessage,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
