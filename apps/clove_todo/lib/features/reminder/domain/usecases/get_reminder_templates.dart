import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/entities.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case for getting reminder templates with optional filtering
class GetReminderTemplates implements UseCase<List<ReminderTemplate>, GetReminderTemplatesParams> {
  final ReminderRepository repository;

  const GetReminderTemplates(this.repository);

  @override
  Future<Either<Failure, List<ReminderTemplate>>> call(GetReminderTemplatesParams params) async {
    try {
      // Get templates based on the filter type
      final Either<Failure, List<ReminderTemplate>> result;

      if (params.defaultOnly) {
        result = await repository.getDefaultReminderTemplates();
      } else {
        result = await repository.getReminderTemplates();
      }

      return result.fold((failure) => Left(failure), (templates) {
        // Apply additional filters
        List<ReminderTemplate> filteredTemplates = templates;

        if (params.customOnly) {
          filteredTemplates = filteredTemplates.where((template) => !template.isDefault).toList();
        }

        if (params.typeFilter != null) {
          filteredTemplates = filteredTemplates.where((template) => template.type == params.typeFilter).toList();
        }

        if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
          final query = params.searchQuery!.toLowerCase();
          filteredTemplates = filteredTemplates.where((template) {
            return template.name.toLowerCase().contains(query) || template.description.toLowerCase().contains(query);
          }).toList();
        }

        // Sort templates if requested
        if (params.sortByName) {
          filteredTemplates.sort((a, b) => a.name.compareTo(b.name));
        } else if (params.sortByMinutesBefore) {
          filteredTemplates.sort((a, b) => a.minutesBefore.compareTo(b.minutesBefore));
        } else if (params.sortByCreatedDate) {
          filteredTemplates.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        }

        // Apply reverse sorting if requested
        if (params.reverseSort) {
          filteredTemplates = filteredTemplates.reversed.toList();
        }

        return Right(filteredTemplates);
      });
    } catch (e) {
      return Left(GeneralFailure('Failed to get reminder templates: ${e.toString()}'));
    }
  }
}

/// Parameters for GetReminderTemplates use case
class GetReminderTemplatesParams extends Equatable {
  final bool defaultOnly; // Only default templates
  final bool customOnly; // Only custom (non-default) templates
  final ReminderType? typeFilter; // Filter by reminder type
  final String? searchQuery; // Search in name and description
  final bool sortByName; // Sort by template name
  final bool sortByMinutesBefore; // Sort by minutes before value
  final bool sortByCreatedDate; // Sort by creation date
  final bool reverseSort; // Reverse the sort order

  const GetReminderTemplatesParams({
    this.defaultOnly = false,
    this.customOnly = false,
    this.typeFilter,
    this.searchQuery,
    this.sortByName = true,
    this.sortByMinutesBefore = false,
    this.sortByCreatedDate = false,
    this.reverseSort = false,
  });

  @override
  List<Object?> get props => [
    defaultOnly,
    customOnly,
    typeFilter,
    searchQuery,
    sortByName,
    sortByMinutesBefore,
    sortByCreatedDate,
    reverseSort,
  ];
}
