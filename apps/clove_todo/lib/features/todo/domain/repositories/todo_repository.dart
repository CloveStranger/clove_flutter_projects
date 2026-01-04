import '../entities/todo.dart';

/// Abstract repository interface for Todo operations
abstract class TodoRepository {
  /// Get all todos
  Future<List<Todo>> getTodos();

  /// Get a specific todo by id
  Future<Todo> getTodoById(String id);

  /// Add a new todo
  Future<Todo> addTodo(Todo todo);

  /// Update an existing todo
  Future<Todo> updateTodo(Todo todo);

  /// Delete a todo`
  Future<void> deleteTodo(String id);

  /// Toggle todo completion status
  Future<Todo> toggleTodo(String id);
}
