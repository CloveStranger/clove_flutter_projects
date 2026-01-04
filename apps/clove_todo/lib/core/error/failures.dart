/// Base class for all failures (used as domain-level exceptions)
abstract class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'Failure: $message';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// General failures
class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}

/// Not found failures (when requested resource doesn't exist)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Conflict failures (when data conflicts occur during sync)
class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

/// Database-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Sync-related failures
class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}
