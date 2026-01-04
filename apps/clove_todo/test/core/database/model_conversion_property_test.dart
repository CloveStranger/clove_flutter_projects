import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/features/schedule/data/models/schedule_model.dart';
import 'package:clove_todo/features/schedule/domain/entities/schedule.dart';
import 'package:clove_todo/features/schedule/domain/entities/priority.dart';
import 'package:clove_todo/features/schedule/domain/entities/repeat_rule.dart';
import 'package:clove_todo/features/schedule/domain/entities/repeat_type.dart';
import 'dart:math';

/// Property-based test generator for Schedule entities
class ScheduleGenerator {
  static final Random _random = Random();

  static Schedule generateSchedule() {
    final now = DateTime.now();
    final startTime = now.add(Duration(minutes: _random.nextInt(1440))); // Random time within 24 hours
    final endTime = startTime.add(Duration(minutes: _random.nextInt(480) + 30)); // 30 minutes to 8 hours later

    RepeatRule? repeatRule;
    if (_random.nextBool()) {
      switch (_random.nextInt(4)) {
        case 0:
          repeatRule = RepeatRule.daily(interval: _random.nextInt(7) + 1);
          break;
        case 1:
          repeatRule = RepeatRule.weekly(
            daysOfWeek: List.generate(_random.nextInt(7) + 1, (_) => _random.nextInt(7) + 1).toSet().toList(),
            interval: _random.nextInt(4) + 1,
          );
          break;
        case 2:
          repeatRule = RepeatRule.monthly(interval: _random.nextInt(12) + 1);
          break;
        case 3:
          repeatRule = RepeatRule.yearly(interval: _random.nextInt(5) + 1);
          break;
      }
    }

    return Schedule.create(
      id: 'schedule_${_random.nextInt(1000000)}',
      title: 'Test Schedule ${_random.nextInt(1000)}',
      startTime: startTime,
      endTime: endTime,
      categoryId: 'category_${_random.nextInt(10)}',
      priority: Priority.values[_random.nextInt(Priority.values.length)],
      description: _random.nextBool() ? 'Description ${_random.nextInt(100)}' : null,
      location: _random.nextBool() ? 'Location ${_random.nextInt(100)}' : null,
      repeatRule: repeatRule,
    );
  }
}

void main() {
  group('**Feature: clove-todo-scheduling, Property 12: Data Persistence Durability (Model Conversion)**', () {
    test(
      'Property 12: Model conversion round-trip preserves all data - For any schedule entity, converting to model and back should preserve all data',
      () {
        // Property-based test with 100 iterations
        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random schedule data
          final originalSchedule = ScheduleGenerator.generateSchedule();

          // Convert to model and back
          final model = ScheduleModel.fromEntity(originalSchedule);
          final convertedSchedule = model.toEntity();

          // Verify all data is preserved
          expect(
            convertedSchedule.id,
            equals(originalSchedule.id),
            reason: 'Schedule ID should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.title,
            equals(originalSchedule.title),
            reason: 'Schedule title should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.description,
            equals(originalSchedule.description),
            reason: 'Schedule description should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.startTime,
            equals(originalSchedule.startTime),
            reason: 'Schedule start time should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.endTime,
            equals(originalSchedule.endTime),
            reason: 'Schedule end time should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.location,
            equals(originalSchedule.location),
            reason: 'Schedule location should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.categoryId,
            equals(originalSchedule.categoryId),
            reason: 'Schedule category ID should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.priority,
            equals(originalSchedule.priority),
            reason: 'Schedule priority should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.isCompleted,
            equals(originalSchedule.isCompleted),
            reason: 'Schedule completion status should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.deviceId,
            equals(originalSchedule.deviceId),
            reason: 'Schedule device ID should be preserved (iteration $iteration)',
          );
          expect(
            convertedSchedule.syncHash,
            equals(originalSchedule.syncHash),
            reason: 'Schedule sync hash should be preserved (iteration $iteration)',
          );

          // Verify repeat rule preservation
          if (originalSchedule.repeatRule != null) {
            expect(
              convertedSchedule.repeatRule,
              isNotNull,
              reason: 'Repeat rule should be preserved when present (iteration $iteration)',
            );
            expect(
              convertedSchedule.repeatRule!.type,
              equals(originalSchedule.repeatRule!.type),
              reason: 'Repeat rule type should be preserved (iteration $iteration)',
            );
            expect(
              convertedSchedule.repeatRule!.interval,
              equals(originalSchedule.repeatRule!.interval),
              reason: 'Repeat rule interval should be preserved (iteration $iteration)',
            );
            expect(
              convertedSchedule.repeatRule!.daysOfWeek,
              equals(originalSchedule.repeatRule!.daysOfWeek),
              reason: 'Repeat rule days of week should be preserved (iteration $iteration)',
            );
          } else {
            expect(
              convertedSchedule.repeatRule,
              isNull,
              reason: 'Repeat rule should remain null when not set (iteration $iteration)',
            );
          }
        }
      },
    );

    test(
      'Property 12: JSON serialization round-trip preserves all data - For any schedule model, JSON serialization and deserialization should preserve all data',
      () {
        // Property-based test with 100 iterations
        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random schedule and convert to model
          final originalSchedule = ScheduleGenerator.generateSchedule();
          final originalModel = ScheduleModel.fromEntity(originalSchedule);

          // Serialize to JSON and back
          final json = originalModel.toJson();
          final deserializedModel = ScheduleModel.fromJson(json);

          // Verify all data is preserved
          expect(
            deserializedModel.scheduleId,
            equals(originalModel.scheduleId),
            reason: 'Schedule ID should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.title,
            equals(originalModel.title),
            reason: 'Schedule title should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.description,
            equals(originalModel.description),
            reason: 'Schedule description should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.startTime,
            equals(originalModel.startTime),
            reason: 'Schedule start time should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.endTime,
            equals(originalModel.endTime),
            reason: 'Schedule end time should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.location,
            equals(originalModel.location),
            reason: 'Schedule location should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.categoryId,
            equals(originalModel.categoryId),
            reason: 'Schedule category ID should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.priority,
            equals(originalModel.priority),
            reason: 'Schedule priority should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.isCompleted,
            equals(originalModel.isCompleted),
            reason: 'Schedule completion status should be preserved in JSON (iteration $iteration)',
          );
          expect(
            deserializedModel.repeatRuleJson,
            equals(originalModel.repeatRuleJson),
            reason: 'Repeat rule JSON should be preserved (iteration $iteration)',
          );

          // Verify the deserialized model can be converted back to entity correctly
          final finalSchedule = deserializedModel.toEntity();
          expect(
            finalSchedule.id,
            equals(originalSchedule.id),
            reason: 'Final schedule ID should match original (iteration $iteration)',
          );
          expect(
            finalSchedule.title,
            equals(originalSchedule.title),
            reason: 'Final schedule title should match original (iteration $iteration)',
          );
        }
      },
    );

    test(
      'Property 12: Edge cases preserve data integrity - For any schedule with edge case values, conversion should preserve data integrity',
      () {
        final edgeCases = [
          // Minimum valid schedule
          Schedule.create(
            id: 'min',
            title: 'A',
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(minutes: 1)),
            categoryId: 'c',
            priority: Priority.low,
          ),
          // Schedule with special characters
          Schedule.create(
            id: 'special_chars_🚀',
            title: 'Title with émojis 🎉 and spëcial chars',
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 1)),
            categoryId: 'special_cat',
            priority: Priority.high,
            description: 'Description with\nnewlines\tand\ttabs',
            location: 'Location with "quotes" and \'apostrophes\'',
          ),
          // Schedule with very long strings
          Schedule.create(
            id: 'long_strings',
            title: 'Very long title ' * 50,
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 2)),
            categoryId: 'long_cat',
            priority: Priority.medium,
            description: 'Very long description ' * 100,
            location: 'Very long location ' * 30,
          ),
          // Schedule with complex repeat rule
          Schedule.create(
            id: 'complex_repeat',
            title: 'Complex Repeat Schedule',
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 1)),
            categoryId: 'repeat_cat',
            priority: Priority.high,
            repeatRule: RepeatRule.weekly(
              daysOfWeek: [1, 3, 5, 7],
              interval: 2,
              endDate: DateTime.now().add(const Duration(days: 365)),
            ),
          ),
        ];

        for (int i = 0; i < edgeCases.length; i++) {
          final originalSchedule = edgeCases[i];

          // Test model conversion
          final model = ScheduleModel.fromEntity(originalSchedule);
          final convertedSchedule = model.toEntity();

          expect(
            convertedSchedule.id,
            equals(originalSchedule.id),
            reason: 'Edge case $i: Schedule ID should be preserved',
          );
          expect(
            convertedSchedule.title,
            equals(originalSchedule.title),
            reason: 'Edge case $i: Schedule title should be preserved',
          );
          expect(
            convertedSchedule.description,
            equals(originalSchedule.description),
            reason: 'Edge case $i: Schedule description should be preserved',
          );
          expect(
            convertedSchedule.location,
            equals(originalSchedule.location),
            reason: 'Edge case $i: Schedule location should be preserved',
          );

          // Test JSON serialization
          final json = model.toJson();
          final deserializedModel = ScheduleModel.fromJson(json);
          final finalSchedule = deserializedModel.toEntity();

          expect(
            finalSchedule.id,
            equals(originalSchedule.id),
            reason: 'Edge case $i: JSON round-trip should preserve ID',
          );
          expect(
            finalSchedule.title,
            equals(originalSchedule.title),
            reason: 'Edge case $i: JSON round-trip should preserve title',
          );
        }
      },
    );
  });
}
