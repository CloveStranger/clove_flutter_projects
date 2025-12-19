import 'package:clove_todo/core/usecase/usecase.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';

/// Parameters for ToggleTodo use case
class ToggleTodoParams {
  final String id;

  const ToggleTodoParams(this.id);
}

/// Use case for toggling todo completion status
class ToggleTodo implements UseCase<Todo, ToggleTodoParams> {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  @override
  Future<Todo> call(ToggleTodoParams params) {
    return repository.toggleTodo(params.id);
  }
}

