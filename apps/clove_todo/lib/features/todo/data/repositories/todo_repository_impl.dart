import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';
import '../models/todo_model.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

/// Implementation of TodoRepository
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final isOnline = await networkInfo.isConnected;
      if (isOnline) {
        final remoteTodos = await remoteDataSource.getTodos();
        await localDataSource.cacheTodos(remoteTodos);
        return remoteTodos.map((model) => model.toEntity()).toList();
      }

      final localTodos = await localDataSource.getTodos();
      return localTodos.map((model) => model.toEntity()).toList();
    } on AppException catch (e) {
      throw _mapExceptionToFailure(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw GeneralFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Todo> getTodoById(String id) async {
    try {
      final isOnline = await networkInfo.isConnected;
      if (isOnline) {
        final remoteTodo = await remoteDataSource.getTodoById(id);
        await localDataSource.addTodo(remoteTodo);
        return remoteTodo.toEntity();
      }

      final localTodo = await localDataSource.getTodoById(id);
      if (localTodo != null) {
        return localTodo.toEntity();
      }
      throw const CacheFailure('Todo not found in cache');
    } on AppException catch (e) {
      throw _mapExceptionToFailure(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw GeneralFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);

    // Optimistically update local cache
    await localDataSource.addTodo(todoModel);

    try {
      final isOnline = await networkInfo.isConnected;
      if (isOnline) {
        final remoteTodo = await remoteDataSource.addTodo(todoModel);
        await localDataSource.updateTodo(remoteTodo);
        return remoteTodo.toEntity();
      }

      // Offline: return cached version
      return todoModel.toEntity();
    } on AppException catch (e) {
      throw _mapExceptionToFailure(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw GeneralFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);

    // Optimistically update local cache
    await localDataSource.updateTodo(todoModel);

    try {
      final isOnline = await networkInfo.isConnected;
      if (isOnline) {
        final remoteTodo = await remoteDataSource.updateTodo(todoModel);
        await localDataSource.updateTodo(remoteTodo);
        return remoteTodo.toEntity();
      }

      // Offline: return cached version
      return todoModel.toEntity();
    } on AppException catch (e) {
      throw _mapExceptionToFailure(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw GeneralFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    // Optimistically delete from local cache
    await localDataSource.deleteTodo(id);

    try {
      final isOnline = await networkInfo.isConnected;
      if (isOnline) {
        await remoteDataSource.deleteTodo(id);
      }
    } on AppException catch (e) {
      throw _mapExceptionToFailure(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw GeneralFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Todo> toggleTodo(String id) async {
    final todo = await getTodoById(id);
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedAt: DateTime.now(),
    );
    return updateTodo(updatedTodo);
  }

  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }
    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }
    return GeneralFailure(exception.message);
  }
}

