import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/entities.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case for creating a new reminder template
class CreateReminderTemplate implements UseCase<ReminderTemplate, CreateReminderTemplateParams> {
  final ReminderRepository repository;

  const CreateReminderTemplate(this.repository);

  @override
  Future<Either<Failure, ReminderTemplate>> call(CreateReminderTemplateParams params) async {
    try {
      // Validate the template parameters
      final validationResult = _validateTemplate(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Create the reminder template entity
      final template = ReminderTemplate.create(
        id: params.id,
        name: params.name,
        description: params.description,
        minutesBefore: params.minutesBefore,
        type: params.type,
        customMessage: params.customMessage,
        isDefault: params.isDefault,
      );

      // Add the template through repository
      return repository.addReminderTemplate(template);
    } catch (e) {
      return Left(GeneralFailure('Failed to create reminder template: ${e.toString()}'));
    }
  }

  /// Validate template parameters
  String? _validateTemplate(CreateReminderTemplateParams params) {
    if (params.id.trim().isEmpty) {
      return 'Template ID cannot be empty';
    }

    if (params.name.trim().isEmpty) {
      return 'Template name cannot be empty';
    }

    if (params.description.trim().isEmpty) {
      return 'Template description cannot be empty';
    }

    if (params.minutesBefore < 0) {
      return 'Minutes before cannot be negative';
    }

    // Validate name length
    if (params.name.length > 100) {
      return 'Template name cannot exceed 100 characters';
    }

    // Validate description length
    if (params.description.length > 500) {
      return 'Template description cannot exceed 500 characters';
    }

    // Validate custom message length
    if (params.customMessage != null && params.customMessage!.length > 500) {
      return 'Custom message cannot exceed 500 characters';
    }

    return null; // No validation errors
  }
}

/// Parameters for CreateReminderTemplate use case
class CreateReminderTemplateParams extends Equatable {
  final String id;
  final String name;
  final String description;
  final int minutesBefore;
  final ReminderType type;
  final String? customMessage;
  final bool isDefault;

  const CreateReminderTemplateParams({
    required this.id,
    required this.name,
    required this.description,
    required this.minutesBefore,
    required this.type,
    this.customMessage,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, description, minutesBefore, type, customMessage, isDefault];
}
