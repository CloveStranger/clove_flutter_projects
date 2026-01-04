import '../utils/constants.dart';

/// Validation utility functions
class Validators {
  /// Validates if string is not empty
  static String? notEmpty(String? value, {String? errorMessage}) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage ?? 'This field cannot be empty';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value, {String? errorMessage}) {
    if (value == null || value.isEmpty) {
      return errorMessage ?? 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return errorMessage ?? 'Please enter a valid email';
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int min, {String? errorMessage}) {
    if (value == null || value.length < min) {
      return errorMessage ?? 'Minimum length is $min characters';
    }
    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int max, {String? errorMessage}) {
    if (value == null || value.length > max) {
      return errorMessage ?? 'Maximum length is $max characters';
    }
    return null;
  }

  /// Validates schedule title
  static String? scheduleTitle(String? value) {
    final emptyCheck = notEmpty(value, errorMessage: 'Schedule title is required');
    if (emptyCheck != null) return emptyCheck;

    return maxLength(
      value,
      AppConstants.maxScheduleTitleLength,
      errorMessage: 'Title cannot exceed ${AppConstants.maxScheduleTitleLength} characters',
    );
  }

  /// Validates schedule description
  static String? scheduleDescription(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    return maxLength(
      value,
      AppConstants.maxScheduleDescriptionLength,
      errorMessage: 'Description cannot exceed ${AppConstants.maxScheduleDescriptionLength} characters',
    );
  }

  /// Validates schedule location
  static String? scheduleLocation(String? value) {
    if (value == null || value.isEmpty) return null; // Optional field

    return maxLength(
      value,
      AppConstants.maxScheduleLocationLength,
      errorMessage: 'Location cannot exceed ${AppConstants.maxScheduleLocationLength} characters',
    );
  }

  /// Validates that end time is after start time
  static String? validateTimeRange(DateTime? startTime, DateTime? endTime) {
    if (startTime == null || endTime == null) {
      return 'Both start and end times are required';
    }

    if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
      return 'End time must be after start time';
    }

    return null;
  }

  /// Validates that a date is not in the past
  static String? futureDate(DateTime? value, {String? errorMessage}) {
    if (value == null) {
      return errorMessage ?? 'Date is required';
    }

    final now = DateTime.now();
    if (value.isBefore(now)) {
      return errorMessage ?? 'Date cannot be in the past';
    }

    return null;
  }

  /// Validates reminder minutes before (must be positive)
  static String? reminderMinutes(int? value) {
    if (value == null) {
      return 'Reminder time is required';
    }

    if (value <= 0) {
      return 'Reminder must be at least 1 minute before';
    }

    if (value > 10080) {
      // 7 days in minutes
      return 'Reminder cannot be more than 7 days before';
    }

    return null;
  }

  /// Validates device name for sync
  static String? deviceName(String? value) {
    final emptyCheck = notEmpty(value, errorMessage: 'Device name is required');
    if (emptyCheck != null) return emptyCheck;

    final lengthCheck = maxLength(value, 50, errorMessage: 'Device name cannot exceed 50 characters');
    if (lengthCheck != null) return lengthCheck;

    // Check for valid characters (alphanumeric, spaces, hyphens, underscores)
    final validChars = RegExp(r'^[a-zA-Z0-9\s\-_]+$');
    if (!validChars.hasMatch(value!)) {
      return 'Device name can only contain letters, numbers, spaces, hyphens, and underscores';
    }

    return null;
  }

  /// Validates IP address format
  static String? ipAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'IP address is required';
    }

    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    if (!ipRegex.hasMatch(value)) {
      return 'Please enter a valid IP address';
    }

    return null;
  }

  /// Validates port number
  static String? portNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Port number is required';
    }

    final port = int.tryParse(value);
    if (port == null) {
      return 'Port must be a number';
    }

    if (port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }

    return null;
  }
}
