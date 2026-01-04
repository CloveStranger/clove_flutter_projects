import 'package:intl/intl.dart';

/// Date and time utility functions for the scheduling application
class DateHelpers {
  // Date formatters
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _displayDateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _displayTimeFormat = DateFormat('h:mm a');
  static final DateFormat _displayDateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');

  /// Formats date to string (yyyy-MM-dd)
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formats time to string (HH:mm)
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  /// Formats datetime to string (yyyy-MM-dd HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Formats date for display (MMM dd, yyyy)
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  /// Formats time for display (h:mm a)
  static String formatDisplayTime(DateTime time) {
    return _displayTimeFormat.format(time);
  }

  /// Formats datetime for display (MMM dd, yyyy h:mm a)
  static String formatDisplayDateTime(DateTime dateTime) {
    return _displayDateTimeFormat.format(dateTime);
  }

  /// Parses date string (yyyy-MM-dd)
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parses datetime string (yyyy-MM-dd HH:mm)
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Returns true if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  /// Returns true if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Returns true if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Returns true if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Returns the start of day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns the end of day (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Returns the start of week (Monday 00:00:00)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    final monday = date.subtract(Duration(days: daysFromMonday));
    return startOfDay(monday);
  }

  /// Returns the end of week (Sunday 23:59:59.999)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    final sunday = date.add(Duration(days: daysToSunday));
    return endOfDay(sunday);
  }

  /// Returns the start of month (1st day 00:00:00)
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Returns the end of month (last day 23:59:59.999)
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final lastDay = nextMonth.subtract(const Duration(days: 1));
    return endOfDay(lastDay);
  }

  /// Adds business days (excludes weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var remainingDays = days;

    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday <= 5) {
        // Monday = 1, Friday = 5
        remainingDays--;
      }
    }

    return result;
  }

  /// Calculates reminder time based on schedule start time and minutes before
  static DateTime calculateReminderTime(DateTime scheduleTime, int minutesBefore) {
    return scheduleTime.subtract(Duration(minutes: minutesBefore));
  }

  /// Returns a human-readable relative time string
  static String getRelativeTimeString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past dates
      final absDifference = difference.abs();
      if (absDifference.inMinutes < 1) {
        return 'Just now';
      } else if (absDifference.inMinutes < 60) {
        return '${absDifference.inMinutes} minutes ago';
      } else if (absDifference.inHours < 24) {
        return '${absDifference.inHours} hours ago';
      } else if (absDifference.inDays < 7) {
        return '${absDifference.inDays} days ago';
      } else {
        return formatDisplayDate(dateTime);
      }
    } else {
      // Future dates
      if (difference.inMinutes < 1) {
        return 'Now';
      } else if (difference.inMinutes < 60) {
        return 'In ${difference.inMinutes} minutes';
      } else if (difference.inHours < 24) {
        return 'In ${difference.inHours} hours';
      } else if (difference.inDays < 7) {
        return 'In ${difference.inDays} days';
      } else {
        return formatDisplayDate(dateTime);
      }
    }
  }

  /// Returns the next occurrence of a specific time on a given day
  static DateTime getNextOccurrence(DateTime baseDate, TimeOfDay time) {
    final nextOccurrence = DateTime(baseDate.year, baseDate.month, baseDate.day, time.hour, time.minute);

    // If the time has already passed today, return tomorrow's occurrence
    if (nextOccurrence.isBefore(DateTime.now())) {
      return nextOccurrence.add(const Duration(days: 1));
    }

    return nextOccurrence;
  }

  /// Generates a list of dates between start and end (inclusive)
  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = startOfDay(start);
    final endDate = startOfDay(end);

    while (!current.isAfter(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Returns the number of days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = startOfDay(start);
    final endDate = startOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  /// Checks if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Returns the number of days in a given month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Converts TimeOfDay to DateTime (using today's date)
  static DateTime timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  /// Converts DateTime to TimeOfDay
  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Returns true if this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Returns true if this date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Returns true if this date is today
  bool get isToday => DateHelpers.isToday(this);

  /// Returns true if this date is tomorrow
  bool get isTomorrow => DateHelpers.isTomorrow(this);

  /// Returns true if this date is yesterday
  bool get isYesterday => DateHelpers.isYesterday(this);

  /// Returns the start of day for this date
  DateTime get startOfDay => DateHelpers.startOfDay(this);

  /// Returns the end of day for this date
  DateTime get endOfDay => DateHelpers.endOfDay(this);

  /// Returns a human-readable relative time string
  String get relativeTime => DateHelpers.getRelativeTimeString(this);
}

/// TimeOfDay class for compatibility (if not using Flutter's TimeOfDay)
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDay && runtimeType == other.runtimeType && hour == other.hour && minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
