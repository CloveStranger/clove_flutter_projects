import 'package:get_it/get_it.dart';
import 'package:clove_todo/core/network/api_client.dart';
import 'package:clove_todo/core/network/network_info.dart';
import 'package:clove_todo/core/utils/constants.dart';
import 'package:clove_todo/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:clove_todo/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:clove_todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:clove_todo/features/todo/domain/usecases/add_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/get_todos.dart';
import 'package:clove_todo/features/todo/domain/usecases/toggle_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/update_todo.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection container
Future<void> init() async {
  //! Features - Todo
  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      addTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
      toggleTodo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => ToggleTodo(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  sl.registerLazySingleton(
    () => ApiClient(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
    ),
  );
}

/// Implementation of NetworkInfo
/// TODO: Replace with actual network connectivity checker (connectivity_plus package)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For now, always return true
    // In production, use connectivity_plus package to check actual connectivity
    return true;
  }
}

