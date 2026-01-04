import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/main.dart' as app;
import 'package:clove_todo/core/database/database_service.dart';
import 'package:clove_todo/features/schedule/data/models/schedule_model.dart';
import 'package:clove_todo/features/schedule/domain/entities/schedule.dart';
import 'package:clove_todo/features/schedule/domain/entities/priority.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:math';

/// Property-based test generator for Schedule entities
class ScheduleGenerator {
  static final Random _random = Random();

  static Schedule generateSchedule() {
    final now = DateTime.now();
    final startTime = now.add(Duration(minutes: _random.nextInt(1440))); // Random time within 24 hours
    final endTime = startTime.add(Duration(minutes: _random.nextInt(480) + 30)); // 30 minutes to 8 hours later

    return Schedule.create(
      id: 'schedule_${_random.nextInt(1000000)}',
      title: 'Test Schedule ${_random.nextInt(1000)}',
      startTime: startTime,
      endTime: endTime,
      categoryId: 'category_${_random.nextInt(10)}',
      priority: Priority.values[_random.nextInt(Priority.values.length)],
      description: _random.nextBool() ? 'Description ${_random.nextInt(100)}' : null,
      location: _random.nextBool() ? 'Location ${_random.nextInt(100)}' : null,
    );
  }
}

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('**Feature: clove-todo-scheduling, Property 12: Data Persistence Durability (Integration)**', () {
    late DatabaseService databaseService;

    setUpAll(() async {
      // Initialize the database service
      databaseService = DatabaseService();
      await databaseService.initialize();
    });

    tearDownAll(() async {
      await databaseService.close();
    });

    testWidgets(
      'Property 12: Data Persistence Durability - For any schedule item saved to the database, the item should remain accessible after application restart',
      (WidgetTester tester) async {
        // Property-based test with 50 iterations (reduced for integration test performance)
        for (int iteration = 0; iteration < 50; iteration++) {
          // Generate random schedule data
          final originalSchedule = ScheduleGenerator.generateSchedule();

          // Save to database
          final scheduleBox = databaseService.store.box<ScheduleModel>();
          final scheduleModel = ScheduleModel.fromEntity(originalSchedule);
          final savedId = scheduleBox.put(scheduleModel);

          // Verify immediate persistence
          final immediateRetrieved = scheduleBox.get(savedId);
          expect(
            immediateRetrieved,
            isNotNull,
            reason: 'Schedule should be immediately retrievable after saving (iteration $iteration)',
          );

          // Simulate application restart by closing and reopening the database
          await databaseService.close();
          await databaseService.initialize();

          // Verify data persistence after "restart"
          final newScheduleBox = databaseService.store.box<ScheduleModel>();
          final retrievedAfterRestart = newScheduleBox.get(savedId);
          expect(
            retrievedAfterRestart,
            isNotNull,
            reason: 'Schedule should remain accessible after application restart (iteration $iteration)',
          );

          // Verify data integrity
          final retrievedSchedule = retrievedAfterRestart!.toEntity();
          expect(
            retrievedSchedule.id,
            equals(originalSchedule.id),
            reason: 'Schedule ID should be preserved (iteration $iteration)',
          );
          expect(
            retrievedSchedule.title,
            equals(originalSchedule.title),
            reason: 'Schedule title should be preserved (iteration $iteration)',
          );
          expect(
            retrievedSchedule.startTime,
            equals(originalSchedule.startTime),
            reason: 'Schedule start time should be preserved (iteration $iteration)',
          );
          expect(
            retrievedSchedule.endTime,
            equals(originalSchedule.endTime),
            reason: 'Schedule end time should be preserved (iteration $iteration)',
          );
          expect(
            retrievedSchedule.priority,
            equals(originalSchedule.priority),
            reason: 'Schedule priority should be preserved (iteration $iteration)',
          );
          expect(
            retrievedSchedule.categoryId,
            equals(originalSchedule.categoryId),
            reason: 'Schedule category ID should be preserved (iteration $iteration)',
          );

          // Clean up for next iteration
          newScheduleBox.remove(savedId);
        }
      },
    );

    testWidgets('Property 12 Extended: Batch data persistence durability', (WidgetTester tester) async {
      // Test with multiple schedules at once
      for (int batchIteration = 0; batchIteration < 5; batchIteration++) {
        // Generate a batch of random schedules
        final originalSchedules = List.generate(5, (_) => ScheduleGenerator.generateSchedule());

        // Save all schedules to database
        final scheduleBox = databaseService.store.box<ScheduleModel>();
        final savedIds = <int>[];

        for (final schedule in originalSchedules) {
          final model = ScheduleModel.fromEntity(schedule);
          final savedId = scheduleBox.put(model);
          savedIds.add(savedId);
        }

        // Simulate application restart
        await databaseService.close();
        await databaseService.initialize();

        // Verify all schedules persist after restart
        final newScheduleBox = databaseService.store.box<ScheduleModel>();
        for (int i = 0; i < savedIds.length; i++) {
          final retrievedModel = newScheduleBox.get(savedIds[i]);
          expect(retrievedModel, isNotNull, reason: 'Schedule $i should persist after restart (batch $batchIteration)');

          final retrievedSchedule = retrievedModel!.toEntity();
          final originalSchedule = originalSchedules[i];

          expect(
            retrievedSchedule.id,
            equals(originalSchedule.id),
            reason: 'Schedule $i ID should match (batch $batchIteration)',
          );
          expect(
            retrievedSchedule.title,
            equals(originalSchedule.title),
            reason: 'Schedule $i title should match (batch $batchIteration)',
          );
        }

        // Clean up
        newScheduleBox.removeMany(savedIds);
      }
    });
  });
}
