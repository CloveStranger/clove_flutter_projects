/// Legacy base class for use cases that don't use Either
/// This is for backward compatibility with existing use cases
/// New use cases should use the Either-based UseCase classes
abstract class LegacyUseCase<T, Params> {
  Future<T> call(Params params);
}

/// Legacy use case with no parameters
abstract class LegacyUseCaseNoParams<T> {
  Future<T> call();
}
