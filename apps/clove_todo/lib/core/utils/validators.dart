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
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return errorMessage ?? 'Please enter a valid email';
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(
    String? value,
    int min, {
    String? errorMessage,
  }) {
    if (value == null || value.length < min) {
      return errorMessage ?? 'Minimum length is $min characters';
    }
    return null;
  }

  /// Validates maximum length
  static String? maxLength(
    String? value,
    int max, {
    String? errorMessage,
  }) {
    if (value == null || value.length > max) {
      return errorMessage ?? 'Maximum length is $max characters';
    }
    return null;
  }
}

