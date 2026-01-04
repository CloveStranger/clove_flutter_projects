import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/reminder_repository.dart';

/// Use case for deleting a reminder template
class DeleteReminderTemplate implements UseCase<void, DeleteReminderTemplateParams> {
  final ReminderRepository repository;

  const DeleteReminderTemplate(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteReminderTemplateParams params) async {
    try {
      // Validate the template ID
      if (params.id.trim().isEmpty) {
        return Left(ValidationFailure('Template ID cannot be empty'));
      }

      // Get the existing template first to check if it's a default template
      final existingTemplateResult = await repository.getReminderTemplateById(params.id);

      return existingTemplateResult.fold((failure) => Left(failure), (existingTemplate) async {
        // Check if it's a default template and we're preventing deletion
        if (existingTemplate.isDefault && params.preventDefaultDeletion) {
          return Left(ConflictFailure('Cannot delete default reminder template'));
        }

        // Delete the template
        return repository.deleteReminderTemplate(params.id);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to delete reminder template: ${e.toString()}'));
    }
  }
}

/// Parameters for DeleteReminderTemplate use case
class DeleteReminderTemplateParams extends Equatable {
  final String id;
  final bool preventDefaultDeletion; // Prevent deletion of default templates

  const DeleteReminderTemplateParams({required this.id, this.preventDefaultDeletion = true});

  @override
  List<Object?> get props => [id, preventDefaultDeletion];
}
