import 'package:flutter_test/flutter_test.dart';
import 'package:clove_todo/core/database/database_service.dart';
import 'package:clove_todo/features/schedule/data/models/schedule_model.dart';
import 'package:clove_todo/features/schedule/data/models/category_model.dart';
import 'package:clove_todo/features/reminder/data/models/reminder_model.dart';
import 'package:clove_todo/features/reminder/data/models/reminder_template_model.dart';
import 'package:clove_todo/features/sync/data/models/device_model.dart';
import 'package:clove_todo/features/schedule/domain/entities/schedule.dart';
import 'package:clove_todo/features/schedule/domain/entities/priority.dart';
import 'package:clove_todo/features/schedule/domain/entities/repeat_rule.dart';
import 'package:clove_todo/features/schedule/domain/entities/repeat_type.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder.dart';
import 'package:clove_todo/features/reminder/domain/entities/reminder_type.dart';
import 'package:clove_todo/features/sync/domain/entities/device.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:io';

void main() {
  group('DatabaseService', () {
    late DatabaseService databaseService;
    late Directory tempDir;

    setUp(() async {
      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('objectbox_test_');
      databaseService = DatabaseService();
    });

    tearDown(() async {
      await databaseService.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should initialize database successfully', () async {
      // This test will verify basic initialization
      expect(databaseService.isInitialized, false);

      // Note: We can't easily test initialization without mocking path_provider
      // This is a basic structure test
      expect(() => databaseService.store, throwsA(isA<Exception>()));
    });

    test('should create and convert schedule models correctly', () {
      final now = DateTime.now();
      final schedule = Schedule.create(
        id: 'test-schedule-1',
        title: 'Test Schedule',
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        categoryId: 'test-category',
        priority: Priority.high,
        description: 'Test description',
      );

      final model = ScheduleModel.fromEntity(schedule);
      expect(model.scheduleId, equals('test-schedule-1'));
      expect(model.title, equals('Test Schedule'));
      expect(model.priority, equals(Priority.high.index));

      final convertedBack = model.toEntity();
      expect(convertedBack.id, equals(schedule.id));
      expect(convertedBack.title, equals(schedule.title));
      expect(convertedBack.priority, equals(schedule.priority));
    });

    test('should create and convert reminder models correctly', () {
      final now = DateTime.now();
      final reminder = Reminder.create(
        id: 'test-reminder-1',
        scheduleId: 'test-schedule-1',
        scheduleStartTime: now.add(const Duration(hours: 1)),
        minutesBefore: 30,
        type: ReminderType.notification,
      );

      final model = ReminderModel.fromEntity(reminder);
      expect(model.reminderId, equals('test-reminder-1'));
      expect(model.type, equals(ReminderType.notification.index));
      expect(model.minutesBefore, equals(30));

      final convertedBack = model.toEntity();
      expect(convertedBack.id, equals(reminder.id));
      expect(convertedBack.type, equals(reminder.type));
      expect(convertedBack.minutesBefore, equals(reminder.minutesBefore));
    });

    test('should create and convert category models correctly', () {
      final category = Category.create(id: 'test-category-1', name: 'Work', color: '#2196F3', icon: 'work');

      final model = CategoryModel.fromEntity(category);
      expect(model.categoryId, equals('test-category-1'));
      expect(model.name, equals('Work'));
      expect(model.color, equals('#2196F3'));

      final convertedBack = model.toEntity();
      expect(convertedBack.id, equals(category.id));
      expect(convertedBack.name, equals(category.name));
      expect(convertedBack.color, equals(category.color));
    });

    test('should create and convert device models correctly', () {
      final device = Device.create(
        id: 'test-device-1',
        name: 'Test Device',
        ipAddress: '192.168.1.100',
        port: 8080,
        type: DeviceType.mobile,
      );

      final model = DeviceModel.fromEntity(device);
      expect(model.deviceId, equals('test-device-1'));
      expect(model.name, equals('Test Device'));
      expect(model.ipAddress, equals('192.168.1.100'));
      expect(model.type, equals(DeviceType.mobile.index));

      final convertedBack = model.toEntity();
      expect(convertedBack.id, equals(device.id));
      expect(convertedBack.name, equals(device.name));
      expect(convertedBack.ipAddress, equals(device.ipAddress));
      expect(convertedBack.type, equals(device.type));
    });

    test('should serialize and deserialize models to JSON correctly', () {
      final now = DateTime.now();
      final schedule = Schedule.create(
        id: 'test-schedule-1',
        title: 'Test Schedule',
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        categoryId: 'test-category',
        priority: Priority.medium,
      );

      final model = ScheduleModel.fromEntity(schedule);
      final json = model.toJson();
      final modelFromJson = ScheduleModel.fromJson(json);

      expect(modelFromJson.scheduleId, equals(model.scheduleId));
      expect(modelFromJson.title, equals(model.title));
      expect(modelFromJson.priority, equals(model.priority));
    });

    test('should handle repeat rule serialization correctly', () {
      final now = DateTime.now();
      final schedule = Schedule.create(
        id: 'test-schedule-1',
        title: 'Test Schedule',
        startTime: now,
        endTime: now.add(const Duration(hours: 1)),
        categoryId: 'test-category',
        priority: Priority.low,
        repeatRule: RepeatRule.daily(interval: 2),
      );

      final model = ScheduleModel.fromEntity(schedule);
      expect(model.repeatRuleJson, isNotNull);

      final convertedBack = model.toEntity();
      expect(convertedBack.repeatRule, isNotNull);
      expect(convertedBack.repeatRule!.type, equals(RepeatType.daily));
      expect(convertedBack.repeatRule!.interval, equals(2));
    });
  });
}
