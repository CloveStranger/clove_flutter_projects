import 'package:clove_todo/core/error/exceptions.dart';
import 'package:clove_todo/features/todo/data/models/todo_model.dart';

/// Abstract interface for local data source
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel?> getTodoById(String id);
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

/// Implementation of local data source using in-memory storage
/// TODO: Replace with actual local storage (Hive, SharedPreferences, etc.)
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  // Temporary in-memory storage
  // In production, this should use Hive, SharedPreferences, or SQLite
  final Map<String, TodoModel> _todos = {};

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      return _todos.values.toList();
    } catch (e) {
      throw CacheException('Failed to get todos from cache: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel?> getTodoById(String id) async {
    try {
      return _todos[id];
    } catch (e) {
      throw CacheException('Failed to get todo from cache: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    try {
      for (final todo in todos) {
        _todos[todo.id] = todo;
      }
    } catch (e) {
      throw CacheException('Failed to cache todos: ${e.toString()}');
    }
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    try {
      _todos[todo.id] = todo;
    } catch (e) {
      throw CacheException('Failed to add todo to cache: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    try {
      if (_todos.containsKey(todo.id)) {
        _todos[todo.id] = todo;
      } else {
        throw CacheException('Todo not found in cache');
      }
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to update todo in cache: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      if (_todos.containsKey(id)) {
        _todos.remove(id);
      } else {
        throw CacheException('Todo not found in cache');
      }
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to delete todo from cache: ${e.toString()}');
    }
  }
}

