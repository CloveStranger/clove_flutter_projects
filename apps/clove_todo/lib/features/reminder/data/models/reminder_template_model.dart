import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/entities/reminder_type.dart';

part 'reminder_template_model.g.dart';

/// ObjectBox model for ReminderTemplate entity
@Entity()
@JsonSerializable()
class ReminderTemplateModel {
  @Id()
  int id = 0;

  @Unique()
  String templateId;
  String name;
  String description;
  int minutesBefore;

  @Property(type: PropertyType.byte)
  int type; // ReminderType enum as int

  String? customMessage;
  bool isDefault;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  ReminderTemplateModel({
    required this.templateId,
    required this.name,
    required this.description,
    required this.minutesBefore,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.customMessage,
    this.isDefault = false,
  });

  /// Convert from domain entity to model
  factory ReminderTemplateModel.fromEntity(ReminderTemplate template) {
    return ReminderTemplateModel(
      templateId: template.id,
      name: template.name,
      description: template.description,
      minutesBefore: template.minutesBefore,
      type: template.type.index,
      customMessage: template.customMessage,
      isDefault: template.isDefault,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
    );
  }

  /// Convert from model to domain entity
  ReminderTemplate toEntity() {
    return ReminderTemplate(
      id: templateId,
      name: name,
      description: description,
      minutesBefore: minutesBefore,
      type: ReminderType.values[type],
      customMessage: customMessage,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// JSON serialization for sync
  factory ReminderTemplateModel.fromJson(Map<String, dynamic> json) => _$ReminderTemplateModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderTemplateModelToJson(this);

  @override
  String toString() {
    return 'ReminderTemplateModel(id: $id, templateId: $templateId, name: $name, minutesBefore: $minutesBefore, type: $type, isDefault: $isDefault)';
  }
}
