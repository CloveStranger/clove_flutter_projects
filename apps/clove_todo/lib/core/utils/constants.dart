/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Cache Configuration
  static const String cacheBoxName = 'clove_todo_cache';
  static const int cacheExpirationDays = 7;

  // Todo Configuration
  static const int maxTodoTitleLength = 200;
  static const int maxTodoDescriptionLength = 1000;

  // Schedule Configuration
  static const int maxScheduleTitleLength = 100;
  static const int maxScheduleDescriptionLength = 500;
  static const int maxScheduleLocationLength = 200;
  static const int defaultReminderMinutes = 30;
  static const int maxRemindersPerSchedule = 10;

  // Sync Configuration
  static const int syncTimeoutSeconds = 30;
  static const int maxSyncRetries = 3;
  static const Duration syncRetryDelay = Duration(seconds: 5);
  static const int deviceDiscoveryPort = 8080;
  static const String deviceDiscoveryBroadcast = '255.255.255.255';

  // Database Configuration
  static const String databaseName = 'clove_todo.db';
  static const int databaseVersion = 1;

  // Notification Configuration
  static const String notificationChannelId = 'clove_todo_reminders';
  static const String notificationChannelName = 'Schedule Reminders';
  static const String notificationChannelDescription = 'Notifications for scheduled reminders';
  static const Duration notificationDeliveryTolerance = Duration(seconds: 30);

  // Backup Configuration
  static const String backupFileExtension = '.json';
  static const String backupMimeType = 'application/json';
  static const int maxBackupFiles = 10;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}
