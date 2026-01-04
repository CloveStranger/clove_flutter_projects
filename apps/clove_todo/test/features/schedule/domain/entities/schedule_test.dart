import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/features/schedule/domain/entities/schedule.dart';
import 'package:clove_todo/features/schedule/domain/entities/priority.dart';
import 'package:clove_todo/features/schedule/domain/entities/repeat_rule.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder_type.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

void main() {
  group('Schedule Entity Tests', () {
    group('**Feature: clove-todo-scheduling, Property 4: Schedule Update Timestamp Consistency**', () {
      testProperty(
        'For any schedule update operation, the updated schedule should have a modification timestamp that is after the original creation timestamp',
        () async {
          // Run property test with 100 iterations
          for (int i = 0; i < 100; i++) {
            // Create an initial schedule
            final initialInput = generateValidScheduleInput();
            final originalSchedule = Schedule.create(
              id: initialInput['id'],
              title: initialInput['title'],
              startTime: initialInput['startTime'],
              endTime: initialInput['endTime'],
              categoryId: initialInput['categoryId'],
              priority: initialInput['priority'],
              description: initialInput['description'],
              location: initialInput['location'],
              repeatRule: initialInput['repeatRule'],
              reminders: initialInput['reminders'],
              deviceId: initialInput['deviceId'],
            );

            // Wait a small amount to ensure timestamp difference
            // In real implementation, this would be handled by the system clock
            await Future.delayed(Duration(milliseconds: 1));

            // Generate update parameters
            final updateInput = generateScheduleUpdateInput();

            // Update the schedule
            final updatedSchedule = originalSchedule.copyWith(
              title: updateInput['title'],
              description: updateInput['description'],
              startTime: updateInput['startTime'],
              endTime: updateInput['endTime'],
              location: updateInput['location'],
              priority: updateInput['priority'],
              isCompleted: updateInput['isCompleted'],
              // updatedAt is automatically set by copyWith
            );

            // Verify timestamp consistency
            expect(
              updatedSchedule.updatedAt.isAfter(originalSchedule.createdAt),
              isTrue,
              reason: 'Updated timestamp should be after creation timestamp',
            );

            expect(
              updatedSchedule.updatedAt.isAfter(originalSchedule.updatedAt),
              isTrue,
              reason: 'Updated timestamp should be after previous update timestamp',
            );

            expect(
              updatedSchedule.createdAt.isAtSameMomentAs(originalSchedule.createdAt),
              isTrue,
              reason: 'Creation timestamp should remain unchanged during updates',
            );

            // Verify the update preserved the ID
            expect(
              updatedSchedule.id,
              equals(originalSchedule.id),
              reason: 'Schedule ID should remain unchanged during updates',
            );
          }
        },
      );
    });

    group('**Feature: clove-todo-scheduling, Property 1: Schedule Creation Completeness**', () {
      testProperty(
        'For any valid schedule input containing required fields, creating a schedule should result in a stored schedule item with all provided data and system-generated metadata',
        () {
          // Run property test with 100 iterations
          for (int i = 0; i < 100; i++) {
            final input = generateValidScheduleInput();

            // Create schedule using the factory method
            final schedule = Schedule.create(
              id: input['id'],
              title: input['title'],
              startTime: input['startTime'],
              endTime: input['endTime'],
              categoryId: input['categoryId'],
              priority: input['priority'],
              description: input['description'],
              location: input['location'],
              repeatRule: input['repeatRule'],
              reminders: input['reminders'],
              deviceId: input['deviceId'],
            );

            // Verify all required fields are present and valid
            expect(
              schedule.hasAllRequiredFields(),
              isTrue,
              reason: 'Schedule should have all required fields for input: $input',
            );

            // Verify timestamps are properly set
            expect(
              schedule.hasValidTimestamps(),
              isTrue,
              reason: 'Schedule should have valid timestamps for input: $input',
            );

            // Verify all input data is contained in the schedule
            expect(
              schedule.containsAllInputData(input),
              isTrue,
              reason: 'Schedule should contain all input data for input: $input',
            );

            // Verify system-generated metadata
            expect(schedule.id, equals(input['id']));
            expect(schedule.createdAt, isNotNull);
            expect(schedule.updatedAt, isNotNull);
            expect(schedule.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);
            expect(schedule.updatedAt.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);
          }
        },
      );
    });

    group('Schedule Creation Edge Cases', () {
      test('should handle minimum valid schedule', () {
        final now = DateTime.now();
        final schedule = Schedule.create(
          id: 'test-id',
          title: 'Test',
          startTime: now,
          endTime: now.add(Duration(hours: 1)),
          categoryId: 'category-1',
          priority: Priority.low,
        );

        expect(schedule.hasAllRequiredFields(), isTrue);
        expect(schedule.hasValidTimestamps(), isTrue);
      });

      test('should handle schedule with all optional fields', () {
        final now = DateTime.now().add(Duration(hours: 1)); // Schedule in the future
        final reminders = [
          Reminder.create(
            id: 'reminder-1',
            scheduleId: 'schedule-1',
            scheduleStartTime: now,
            minutesBefore: 30,
            type: ReminderType.notification,
          ),
        ];

        final schedule = Schedule.create(
          id: 'test-id',
          title: 'Test Schedule',
          startTime: now,
          endTime: now.add(Duration(hours: 2)),
          categoryId: 'category-1',
          priority: Priority.high,
          description: 'Test description',
          location: 'Test location',
          repeatRule: RepeatRule.daily(),
          reminders: reminders,
          deviceId: 'device-1',
        );

        expect(schedule.hasAllRequiredFields(), isTrue);
        expect(schedule.hasValidTimestamps(), isTrue);
        expect(schedule.description, equals('Test description'));
        expect(schedule.location, equals('Test location'));
        expect(schedule.repeatRule, isNotNull);
        expect(schedule.reminders.length, equals(1));
        expect(schedule.deviceId, equals('device-1'));
      });
    });

    group('Schedule Validation', () {
      test('should reject empty title', () {
        final now = DateTime.now();
        expect(
          () => Schedule.create(
            id: 'test-id',
            title: '',
            startTime: now,
            endTime: now.add(Duration(hours: 1)),
            categoryId: 'category-1',
            priority: Priority.low,
          ),
          throwsArgumentError,
        );
      });

      test('should reject end time before start time', () {
        final now = DateTime.now();
        expect(
          () => Schedule.create(
            id: 'test-id',
            title: 'Test',
            startTime: now,
            endTime: now.subtract(Duration(hours: 1)),
            categoryId: 'category-1',
            priority: Priority.low,
          ),
          throwsArgumentError,
        );
      });

      test('should reject same start and end time', () {
        final now = DateTime.now();
        expect(
          () => Schedule.create(
            id: 'test-id',
            title: 'Test',
            startTime: now,
            endTime: now,
            categoryId: 'category-1',
            priority: Priority.low,
          ),
          throwsArgumentError,
        );
      });
    });
  });
}

/// Property test helper function
void testProperty(String description, dynamic Function() testFunction) {
  test(description, testFunction);
}

/// Generate valid schedule input for property testing
Map<String, dynamic> generateValidScheduleInput() {
  final random = Random();
  final uuid = Uuid();
  final now = DateTime.now();

  // Generate random but valid times (always in the future)
  final startTime = now.add(
    Duration(
      days: random.nextInt(30) + 1, // At least 1 day in the future
      hours: random.nextInt(24),
      minutes: random.nextInt(60),
    ),
  );
  final endTime = startTime.add(
    Duration(
      hours: random.nextInt(8) + 1, // 1-8 hours duration
      minutes: random.nextInt(60),
    ),
  );

  // Generate random title (1-200 characters)
  final titleLength = random.nextInt(199) + 1;
  final title = 'Test Schedule ${uuid.v4().substring(0, min(titleLength, 36))}';

  // Generate optional description (0-1000 characters)
  final hasDescription = random.nextBool();
  final description = hasDescription ? 'Description ${uuid.v4()}' : null;

  // Generate optional location (0-300 characters)
  final hasLocation = random.nextBool();
  final location = hasLocation ? 'Location ${random.nextInt(1000)}' : null;

  // Generate random priority
  final priorities = Priority.values;
  final priority = priorities[random.nextInt(priorities.length)];

  // Generate optional repeat rule
  final hasRepeatRule = random.nextBool();
  RepeatRule? repeatRule;
  if (hasRepeatRule) {
    final repeatTypes = [
      () => RepeatRule.daily(),
      () => RepeatRule.weekly(daysOfWeek: [1, 3, 5]),
      () => RepeatRule.monthly(),
      () => RepeatRule.yearly(),
    ];
    repeatRule = repeatTypes[random.nextInt(repeatTypes.length)]();
  }

  // Generate optional reminders
  final hasReminders = random.nextBool();
  List<Reminder>? reminders;
  if (hasReminders) {
    final reminderCount = random.nextInt(3) + 1; // 1-3 reminders
    reminders = List.generate(reminderCount, (index) {
      return Reminder.create(
        id: uuid.v4(),
        scheduleId: uuid.v4(),
        scheduleStartTime: startTime,
        minutesBefore: [15, 30, 60, 120][random.nextInt(4)],
        type: ReminderType.notification,
      );
    });
  }

  return {
    'id': uuid.v4(),
    'title': title,
    'startTime': startTime,
    'endTime': endTime,
    'categoryId': 'category-${random.nextInt(10)}',
    'priority': priority,
    'description': description,
    'location': location,
    'repeatRule': repeatRule,
    'reminders': reminders,
    'deviceId': random.nextBool() ? 'device-${random.nextInt(5)}' : null,
  };
}

/// Generate schedule update input for property testing
Map<String, dynamic> generateScheduleUpdateInput() {
  final random = Random();
  final uuid = Uuid();
  final now = DateTime.now();

  // Generate random but valid future times
  final startTime = now.add(
    Duration(days: random.nextInt(30) + 1, hours: random.nextInt(24), minutes: random.nextInt(60)),
  );
  final endTime = startTime.add(Duration(hours: random.nextInt(8) + 1, minutes: random.nextInt(60)));

  // Generate random title (1-200 characters)
  final titleLength = random.nextInt(199) + 1;
  final title = 'Updated Schedule ${uuid.v4().substring(0, min(titleLength, 36))}';

  // Generate optional description
  final hasDescription = random.nextBool();
  final description = hasDescription ? 'Updated Description ${uuid.v4()}' : null;

  // Generate optional location
  final hasLocation = random.nextBool();
  final location = hasLocation ? 'Updated Location ${random.nextInt(1000)}' : null;

  // Generate random priority
  final priorities = Priority.values;
  final priority = priorities[random.nextInt(priorities.length)];

  // Generate random completion status
  final isCompleted = random.nextBool();

  return {
    'title': title,
    'startTime': startTime,
    'endTime': endTime,
    'description': description,
    'location': location,
    'priority': priority,
    'isCompleted': isCompleted,
  };
}
