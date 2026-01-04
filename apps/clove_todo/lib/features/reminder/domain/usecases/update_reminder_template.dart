import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/entities.dart';
import '../repositories/reminder_repository.dart';

/// Use case for updating an existing reminder template
class UpdateReminderTemplate implements UseCase<ReminderTemplate, UpdateReminderTemplateParams> {
  final ReminderRepository repository;

  const UpdateReminderTemplate(this.repository);

  @override
  Future<Either<Failure, ReminderTemplate>> call(UpdateReminderTemplateParams params) async {
    try {
      // Validate the template parameters
      final validationResult = _validateTemplate(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Get the existing template first
      final existingTemplateResult = await repository.getReminderTemplateById(params.id);

      return existingTemplateResult.fold((failure) => Left(failure), (existingTemplate) async {
        // Check if it's a default template and we're trying to modify critical properties
        if (existingTemplate.isDefault && params.preventDefaultModification) {
          return Left(ConflictFailure('Cannot modify default reminder template'));
        }

        // Create updated template
        final updatedTemplate = existingTemplate.copyWith(
          name: params.name,
          description: params.description,
          minutesBefore: params.minutesBefore,
          type: params.type,
          customMessage: params.customMessage,
          isDefault: params.isDefault,
        );

        // Update the template through repository
        return repository.updateReminderTemplate(updatedTemplate);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to update reminder template: ${e.toString()}'));
    }
  }

  /// Validate template parameters
  String? _validateTemplate(UpdateReminderTemplateParams params) {
    if (params.id.trim().isEmpty) {
      return 'Template ID cannot be empty';
    }

    if (params.name != null && params.name!.trim().isEmpty) {
      return 'Template name cannot be empty';
    }

    if (params.description != null && params.description!.trim().isEmpty) {
      return 'Template description cannot be empty';
    }

    if (params.minutesBefore != null && params.minutesBefore! < 0) {
      return 'Minutes before cannot be negative';
    }

    // Validate name length
    if (params.name != null && params.name!.length > 100) {
      return 'Template name cannot exceed 100 characters';
    }

    // Validate description length
    if (params.description != null && params.description!.length > 500) {
      return 'Template description cannot exceed 500 characters';
    }

    // Validate custom message length
    if (params.customMessage != null && params.customMessage!.length > 500) {
      return 'Custom message cannot exceed 500 characters';
    }

    return null; // No validation errors
  }
}

/// Parameters for UpdateReminderTemplate use case
class UpdateReminderTemplateParams extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final int? minutesBefore;
  final ReminderType? type;
  final String? customMessage;
  final bool? isDefault;
  final bool preventDefaultModification; // Prevent modification of default templates

  const UpdateReminderTemplateParams({
    required this.id,
    this.name,
    this.description,
    this.minutesBefore,
    this.type,
    this.customMessage,
    this.isDefault,
    this.preventDefaultModification = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    minutesBefore,
    type,
    customMessage,
    isDefault,
    preventDefaultModification,
  ];
}
