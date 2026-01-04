/// Base class for all exceptions
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => 'Exception: $message';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Network connectivity exceptions
class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException(super.message, [this.statusCode]);
}

/// Data parsing exceptions
class ParsingException extends AppException {
  const ParsingException(super.message);
}

/// Database-related exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

/// Sync-related exceptions
class SyncException extends AppException {
  final SyncErrorType type;
  const SyncException(super.message, this.type);
}

/// Types of sync errors
enum SyncErrorType {
  deviceNotFound,
  connectionTimeout,
  dataCorruption,
  conflictResolution,
  authenticationFailed,
  networkUnavailable,
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException(super.message);
}
