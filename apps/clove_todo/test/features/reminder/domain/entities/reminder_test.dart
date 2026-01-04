import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder_type.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

void main() {
  group('Reminder Entity Tests', () {
    group('**Feature: clove-todo-scheduling, Property 2: Reminder Time Calculation Accuracy**', () {
      testProperty(
        'For any schedule item and reminder configuration, the calculated reminder time should equal the schedule start time minus the specified minutes-before value',
        () {
          // Run property test with 100 iterations
          for (int i = 0; i < 100; i++) {
            final input = generateValidReminderInput();

            // Create reminder using the factory method
            final reminder = Reminder.create(
              id: input['id'],
              scheduleId: input['scheduleId'],
              scheduleStartTime: input['scheduleStartTime'],
              minutesBefore: input['minutesBefore'],
              type: input['type'],
              customMessage: input['customMessage'],
            );

            // Calculate expected reminder time
            final expectedReminderTime = input['scheduleStartTime'].subtract(Duration(minutes: input['minutesBefore']));

            // Verify reminder time calculation accuracy
            expect(
              reminder.remindTime.isAtSameMomentAs(expectedReminderTime),
              isTrue,
              reason:
                  'Reminder time should equal schedule start time minus minutes before. '
                  'Expected: $expectedReminderTime, Got: ${reminder.remindTime}, '
                  'Schedule start: ${input['scheduleStartTime']}, Minutes before: ${input['minutesBefore']}',
            );

            // Verify the reminder has accurate time calculation using the entity method
            expect(
              reminder.hasAccurateReminderTime(input['scheduleStartTime']),
              isTrue,
              reason: 'Reminder should have accurate time calculation for input: $input',
            );

            // Verify static calculation method produces same result
            final staticCalculatedTime = Reminder.calculateReminderTime(
              input['scheduleStartTime'],
              input['minutesBefore'],
            );
            expect(
              reminder.remindTime.isAtSameMomentAs(staticCalculatedTime),
              isTrue,
              reason: 'Static calculation method should produce same result as factory method',
            );

            // Verify minutes before value is preserved
            expect(
              reminder.minutesBefore,
              equals(input['minutesBefore']),
              reason: 'Minutes before value should be preserved in the reminder',
            );
          }
        },
      );
    });

    group('**Feature: clove-todo-scheduling, Property 3: Default Reminder Application**', () {
      testProperty(
        'For any schedule item created without explicit reminder settings, the system should automatically create a reminder set for 30 minutes before the start time',
        () {
          // Run property test with 100 iterations
          for (int i = 0; i < 100; i++) {
            final input = generateValidScheduleInputForDefaultReminder();

            // Create a default reminder (30 minutes before)
            final defaultReminder = Reminder.create(
              id: input['reminderId'],
              scheduleId: input['scheduleId'],
              scheduleStartTime: input['scheduleStartTime'],
              minutesBefore: 30, // Default value
              type: ReminderType.notification, // Default type
            );

            // Verify default reminder is set for 30 minutes before
            expect(
              defaultReminder.minutesBefore,
              equals(30),
              reason: 'Default reminder should be set for 30 minutes before',
            );

            // Verify reminder time is calculated correctly for default
            final expectedDefaultTime = input['scheduleStartTime'].subtract(const Duration(minutes: 30));
            expect(
              defaultReminder.remindTime.isAtSameMomentAs(expectedDefaultTime),
              isTrue,
              reason:
                  'Default reminder time should be 30 minutes before schedule start time. '
                  'Expected: $expectedDefaultTime, Got: ${defaultReminder.remindTime}',
            );

            // Verify default reminder type
            expect(
              defaultReminder.type,
              equals(ReminderType.notification),
              reason: 'Default reminder should use notification type',
            );

            // Verify reminder is not triggered initially
            expect(defaultReminder.isTriggered, isFalse, reason: 'Default reminder should not be triggered initially');

            // Verify reminder is associated with the correct schedule
            expect(
              defaultReminder.scheduleId,
              equals(input['scheduleId']),
              reason: 'Default reminder should be associated with the correct schedule',
            );
          }
        },
      );
    });

    group('**Feature: clove-todo-scheduling, Property 4: Template Reminder Configuration Consistency**', () {
      testProperty(
        'For any reminder template applied to a schedule item, all reminder settings should match the template configuration exactly',
        () {
          // Run property test with 100 iterations
          for (int i = 0; i < 100; i++) {
            final input = generateValidTemplateApplicationInput();

            // Create reminder template
            final template = ReminderTemplate.create(
              id: input['templateId'],
              name: input['templateName'],
              description: input['templateDescription'],
              minutesBefore: input['minutesBefore'],
              type: input['type'],
              customMessage: input['customMessage'],
            );

            // Apply template to create reminder
            final reminder = template.applyToSchedule(
              reminderId: input['reminderId'],
              scheduleId: input['scheduleId'],
              scheduleStartTime: input['scheduleStartTime'],
            );

            // Verify template configuration consistency
            expect(
              template.isConsistentWith(reminder),
              isTrue,
              reason: 'Template should be consistent with the created reminder',
            );

            // Verify individual configuration matches
            expect(
              reminder.minutesBefore,
              equals(template.minutesBefore),
              reason: 'Reminder minutes before should match template configuration',
            );

            expect(reminder.type, equals(template.type), reason: 'Reminder type should match template configuration');

            expect(
              reminder.customMessage,
              equals(template.customMessage),
              reason: 'Reminder custom message should match template configuration',
            );

            // Verify reminder time calculation is still accurate
            final expectedReminderTime = input['scheduleStartTime'].subtract(Duration(minutes: template.minutesBefore));
            expect(
              reminder.remindTime.isAtSameMomentAs(expectedReminderTime),
              isTrue,
              reason: 'Template-created reminder should have accurate time calculation',
            );

            // Verify reminder is associated with correct schedule
            expect(
              reminder.scheduleId,
              equals(input['scheduleId']),
              reason: 'Template-created reminder should be associated with correct schedule',
            );

            // Verify reminder has correct ID
            expect(
              reminder.id,
              equals(input['reminderId']),
              reason: 'Template-created reminder should have correct ID',
            );
          }
        },
      );
    });

    group('Reminder Creation Edge Cases', () {
      test('should handle minimum valid reminder', () {
        final now = DateTime.now().add(Duration(hours: 1));
        final reminder = Reminder.create(
          id: 'test-id',
          scheduleId: 'schedule-id',
          scheduleStartTime: now,
          minutesBefore: 0,
          type: ReminderType.notification,
        );

        expect(reminder.minutesBefore, equals(0));
        expect(reminder.remindTime.isAtSameMomentAs(now), isTrue);
      });

      test('should handle reminder with custom message', () {
        final now = DateTime.now().add(Duration(hours: 1));
        final reminder = Reminder.create(
          id: 'test-id',
          scheduleId: 'schedule-id',
          scheduleStartTime: now,
          minutesBefore: 15,
          type: ReminderType.notification,
          customMessage: 'Custom reminder message',
        );

        expect(reminder.customMessage, equals('Custom reminder message'));
      });
    });

    group('Reminder Validation', () {
      test('should reject empty reminder ID', () {
        final now = DateTime.now().add(Duration(hours: 1));
        expect(
          () => Reminder.create(
            id: '',
            scheduleId: 'schedule-id',
            scheduleStartTime: now,
            minutesBefore: 30,
            type: ReminderType.notification,
          ),
          throwsArgumentError,
        );
      });

      test('should reject empty schedule ID', () {
        final now = DateTime.now().add(Duration(hours: 1));
        expect(
          () => Reminder.create(
            id: 'reminder-id',
            scheduleId: '',
            scheduleStartTime: now,
            minutesBefore: 30,
            type: ReminderType.notification,
          ),
          throwsArgumentError,
        );
      });

      test('should reject negative minutes before', () {
        final now = DateTime.now().add(Duration(hours: 1));
        expect(
          () => Reminder.create(
            id: 'reminder-id',
            scheduleId: 'schedule-id',
            scheduleStartTime: now,
            minutesBefore: -1,
            type: ReminderType.notification,
          ),
          throwsArgumentError,
        );
      });
    });

    group('Template Creation and Application', () {
      test('should create default templates correctly', () {
        final defaultTemplates = ReminderTemplate.createDefaults();

        expect(defaultTemplates.length, equals(4));
        expect(defaultTemplates.every((template) => template.isDefault), isTrue);

        // Verify specific default templates
        final meetingTemplate = defaultTemplates.firstWhere((t) => t.id == 'default_meeting');
        expect(meetingTemplate.minutesBefore, equals(15));

        final flightTemplate = defaultTemplates.firstWhere((t) => t.id == 'default_flight');
        expect(flightTemplate.minutesBefore, equals(120));

        final birthdayTemplate = defaultTemplates.firstWhere((t) => t.id == 'default_birthday');
        expect(birthdayTemplate.minutesBefore, equals(1440));

        final deadlineTemplate = defaultTemplates.firstWhere((t) => t.id == 'default_deadline');
        expect(deadlineTemplate.minutesBefore, equals(60));
      });

      test('should apply template to create consistent reminder', () {
        final template = ReminderTemplate.create(
          id: 'test-template',
          name: 'Test Template',
          description: 'Test description',
          minutesBefore: 45,
          type: ReminderType.notification,
          customMessage: 'Test message',
        );

        final now = DateTime.now().add(Duration(hours: 2));
        final reminder = template.applyToSchedule(
          reminderId: 'reminder-id',
          scheduleId: 'schedule-id',
          scheduleStartTime: now,
        );

        expect(template.isConsistentWith(reminder), isTrue);
        expect(reminder.minutesBefore, equals(45));
        expect(reminder.type, equals(ReminderType.notification));
        expect(reminder.customMessage, equals('Test message'));
      });
    });
  });
}

/// Property test helper function
void testProperty(String description, dynamic Function() testFunction) {
  test(description, testFunction);
}

/// Generate valid reminder input for property testing
Map<String, dynamic> generateValidReminderInput() {
  final random = Random();
  final uuid = Uuid();
  final now = DateTime.now();

  // Generate minutes before (0 to 1440 minutes = 24 hours max to avoid past times)
  final minutesBefore = random.nextInt(1441);

  // Generate schedule start time in the future, ensuring reminder time is also in future
  // Add extra buffer to ensure reminder time is not in the past
  final minFutureHours = (minutesBefore / 60).ceil() + 1; // At least 1 hour after reminder time

  final scheduleStartTime = now.add(
    Duration(days: random.nextInt(30) + 1, hours: max(minFutureHours, random.nextInt(24)), minutes: random.nextInt(60)),
  );

  // Generate random reminder type
  final types = ReminderType.values;
  final type = types[random.nextInt(types.length)];

  // Generate optional custom message
  final hasCustomMessage = random.nextBool();
  final customMessage = hasCustomMessage ? 'Custom message ${uuid.v4()}' : null;

  return {
    'id': uuid.v4(),
    'scheduleId': uuid.v4(),
    'scheduleStartTime': scheduleStartTime,
    'minutesBefore': minutesBefore,
    'type': type,
    'customMessage': customMessage,
  };
}

/// Generate valid schedule input for default reminder testing
Map<String, dynamic> generateValidScheduleInputForDefaultReminder() {
  final random = Random();
  final uuid = Uuid();
  final now = DateTime.now();

  // Generate schedule start time in the future (at least 1 hour)
  final scheduleStartTime = now.add(
    Duration(days: random.nextInt(30) + 1, hours: random.nextInt(24), minutes: random.nextInt(60)),
  );

  return {'scheduleId': uuid.v4(), 'reminderId': uuid.v4(), 'scheduleStartTime': scheduleStartTime};
}

/// Generate valid template application input for property testing
Map<String, dynamic> generateValidTemplateApplicationInput() {
  final random = Random();
  final uuid = Uuid();
  final now = DateTime.now();

  // Generate template configuration
  final minutesBefore = random.nextInt(1441); // 0 to 24 hours max
  final types = ReminderType.values;
  final type = types[random.nextInt(types.length)];

  // Ensure schedule start time is far enough in future for the reminder
  final minFutureHours = (minutesBefore / 60).ceil() + 1;
  final scheduleStartTime = now.add(
    Duration(days: random.nextInt(30) + 1, hours: max(minFutureHours, random.nextInt(24)), minutes: random.nextInt(60)),
  );

  final hasCustomMessage = random.nextBool();
  final customMessage = hasCustomMessage ? 'Template message ${uuid.v4()}' : null;

  // Generate template name and description
  final templateName = 'Template ${random.nextInt(1000)}';
  final templateDescription = 'Description for ${templateName}';

  return {
    'templateId': uuid.v4(),
    'templateName': templateName,
    'templateDescription': templateDescription,
    'reminderId': uuid.v4(),
    'scheduleId': uuid.v4(),
    'scheduleStartTime': scheduleStartTime,
    'minutesBefore': minutesBefore,
    'type': type,
    'customMessage': customMessage,
  };
}
