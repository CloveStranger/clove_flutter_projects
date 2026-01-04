import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/core/database/database_service.dart';
import 'package:clove_todo/features/schedule/data/models/schedule_model.dart';
import 'package:clove_todo/features/schedule/domain/entities/schedule.dart';
import 'package:clove_todo/features/schedule/domain/entities/priority.dart';
import 'package:clove_todo/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:io';
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

  static List<Schedule> generateSchedules(int count) {
    return List.generate(count, (_) => generateSchedule());
  }
}

void main() {
  group('**Feature: clove-todo-scheduling, Property 12: Data Persistence Durability**', () {
    late DatabaseService databaseService;
    late Directory tempDir;
    late Store store;

    setUp(() async {
      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('objectbox_property_test_');

      // Initialize ObjectBox store directly for testing
      store = Store.attach(getObjectBoxModel(), tempDir.path);

      databaseService = DatabaseService();
    });

    tearDown(() async {
      store.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    testWidgets(
      'Property 12: Data Persistence Durability - For any schedule item saved to the database, the item should remain accessible after application restart',
      (WidgetTester tester) async {
        // Property-based test with 100 iterations
        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random schedule data
          final originalSchedule = ScheduleGenerator.generateSchedule();

          // Save to database
          final scheduleBox = store.box<ScheduleModel>();
          final scheduleModel = ScheduleModel.fromEntity(originalSchedule);
          final savedId = scheduleBox.put(scheduleModel);

          // Verify immediate persistence
          final immediateRetrieved = scheduleBox.get(savedId);
          expect(
            immediateRetrieved,
            isNotNull,
            reason: 'Schedule should be immediately retrievable after saving (iteration $iteration)',
          );

          // Simulate application restart by closing and reopening the store
          store.close();

          // Reopen store (simulating app restart)
          store = Store.attach(getObjectBoxModel(), tempDir.path);
          final newScheduleBox = store.box<ScheduleModel>();

          // Verify data persistence after "restart"
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
      for (int batchIteration = 0; batchIteration < 10; batchIteration++) {
        // Generate a batch of random schedules
        final originalSchedules = ScheduleGenerator.generateSchedules(10);

        // Save all schedules to database
        final scheduleBox = store.box<ScheduleModel>();
        final savedIds = <int>[];

        for (final schedule in originalSchedules) {
          final model = ScheduleModel.fromEntity(schedule);
          final savedId = scheduleBox.put(model);
          savedIds.add(savedId);
        }

        // Simulate application restart
        store.close();
        store = Store.attach(getObjectBoxModel(), tempDir.path);
        final newScheduleBox = store.box<ScheduleModel>();

        // Verify all schedules persist after restart
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

    testWidgets('Property 12 Edge Cases: Data persistence with special characters and edge values', (
      WidgetTester tester,
    ) async {
      // Test edge cases that might cause persistence issues
      final edgeCases = [
        // Empty strings
        Schedule.create(
          id: 'edge_empty',
          title: 'A', // Minimum valid title
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(minutes: 1)),
          categoryId: 'cat',
          priority: Priority.low,
          description: '',
          location: '',
        ),
        // Special characters
        Schedule.create(
          id: 'edge_special_chars',
          title: 'Test with émojis 🚀 and spëcial chars',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          categoryId: 'special_cat',
          priority: Priority.high,
          description: 'Description with\nnewlines\tand\ttabs',
          location: 'Location with "quotes" and \'apostrophes\'',
        ),
        // Very long strings
        Schedule.create(
          id: 'edge_long_strings',
          title: 'Very long title ' * 50,
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          categoryId: 'long_cat',
          priority: Priority.medium,
          description: 'Very long description ' * 100,
          location: 'Very long location ' * 30,
        ),
      ];

      final scheduleBox = store.box<ScheduleModel>();
      final savedIds = <int>[];

      // Save all edge case schedules
      for (final schedule in edgeCases) {
        final model = ScheduleModel.fromEntity(schedule);
        final savedId = scheduleBox.put(model);
        savedIds.add(savedId);
      }

      // Simulate restart
      store.close();
      store = Store.attach(getObjectBoxModel(), tempDir.path);
      final newScheduleBox = store.box<ScheduleModel>();

      // Verify all edge cases persist correctly
      for (int i = 0; i < savedIds.length; i++) {
        final retrievedModel = newScheduleBox.get(savedIds[i]);
        expect(retrievedModel, isNotNull, reason: 'Edge case schedule $i should persist');

        final retrievedSchedule = retrievedModel!.toEntity();
        final originalSchedule = edgeCases[i];

        expect(retrievedSchedule.id, equals(originalSchedule.id));
        expect(retrievedSchedule.title, equals(originalSchedule.title));
        expect(retrievedSchedule.description, equals(originalSchedule.description));
        expect(retrievedSchedule.location, equals(originalSchedule.location));
      }

      // Clean up
      newScheduleBox.removeMany(savedIds);
    });
  });
}
