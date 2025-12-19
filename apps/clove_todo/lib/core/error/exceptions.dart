/// Base class for all exceptions
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
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
  const NetworkException(super.message);
}

/// Data parsing exceptions
class ParsingException extends AppException {
  const ParsingException(super.message);
}

