import 'package:clove_todo/core/error/exceptions.dart';
import 'package:clove_todo/core/network/api_client.dart';
import 'package:clove_todo/features/todo/data/models/todo_model.dart';

/// Abstract interface for remote data source
abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> addTodo(TodoModel todo);
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

/// Implementation of remote data source using API client
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final ApiClient apiClient;

  TodoRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await apiClient.get('/todos');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw const ParsingException('Invalid response format');
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get todos: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    try {
      final response = await apiClient.get('/todos/$id');
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to get todo: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> addTodo(TodoModel todo) async {
    try {
      final response = await apiClient.post(
        '/todos',
        data: todo.toJson(),
      );
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to add todo: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final response = await apiClient.put(
        '/todos/${todo.id}',
        data: todo.toJson(),
      );
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to update todo: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await apiClient.delete('/todos/$id');
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Failed to delete todo: ${e.toString()}');
    }
  }
}

