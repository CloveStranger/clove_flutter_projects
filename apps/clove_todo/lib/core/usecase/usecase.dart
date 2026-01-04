import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases that return Either<Failure, T>
/// T: Return type
/// Params: Parameters type
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters that returns Either<Failure, T>
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Base class for synchronous use cases that return Either<Failure, T>
abstract class SyncUseCase<T, Params> {
  Either<Failure, T> call(Params params);
}

/// Synchronous use case with no parameters that returns Either<Failure, T>
abstract class SyncUseCaseNoParams<T> {
  Either<Failure, T> call();
}

/// Base class for stream use cases that return Stream<Either<Failure, T>>
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Stream use case with no parameters that returns Stream<Either<Failure, T>>
abstract class StreamUseCaseNoParams<T> {
  Stream<Either<Failure, T>> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => identical(this, other) || other is NoParams;

  @override
  int get hashCode => 0;
}
