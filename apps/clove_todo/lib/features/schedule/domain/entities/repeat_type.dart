/// Types of repeat patterns for schedule items
enum RepeatType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
  custom;

  /// Display name for the repeat type
  String get displayName {
    switch (this) {
      case RepeatType.none:
        return 'No Repeat';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
      case RepeatType.monthly:
        return 'Monthly';
      case RepeatType.yearly:
        return 'Yearly';
      case RepeatType.custom:
        return 'Custom';
    }
  }

  /// Create RepeatType from string value
  static RepeatType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'none':
        return RepeatType.none;
      case 'daily':
        return RepeatType.daily;
      case 'weekly':
        return RepeatType.weekly;
      case 'monthly':
        return RepeatType.monthly;
      case 'yearly':
        return RepeatType.yearly;
      case 'custom':
        return RepeatType.custom;
      default:
        throw ArgumentError('Invalid repeat type value: $value');
    }
  }
}
