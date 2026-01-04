/// Types of reminders that can be delivered
enum ReminderType {
  notification,
  sound,
  vibration,
  email;

  /// Display name for the reminder type
  String get displayName {
    switch (this) {
      case ReminderType.notification:
        return 'Notification';
      case ReminderType.sound:
        return 'Sound';
      case ReminderType.vibration:
        return 'Vibration';
      case ReminderType.email:
        return 'Email';
    }
  }

  /// Check if this reminder type is supported on the current platform
  bool get isSupported {
    switch (this) {
      case ReminderType.notification:
        return true; // Supported on all platforms
      case ReminderType.sound:
        return true; // Supported on all platforms
      case ReminderType.vibration:
        return true; // Supported on mobile platforms
      case ReminderType.email:
        return false; // Not implemented yet
    }
  }

  /// Create ReminderType from string value
  static ReminderType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'notification':
        return ReminderType.notification;
      case 'sound':
        return ReminderType.sound;
      case 'vibration':
        return ReminderType.vibration;
      case 'email':
        return ReminderType.email;
      default:
        throw ArgumentError('Invalid reminder type value: $value');
    }
  }
}
