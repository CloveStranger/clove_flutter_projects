/// Base class for all use cases
/// Type: Return type
/// Params: Parameters type
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}

