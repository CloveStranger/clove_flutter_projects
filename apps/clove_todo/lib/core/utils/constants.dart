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
}

