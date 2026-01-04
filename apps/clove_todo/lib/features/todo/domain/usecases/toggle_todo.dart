import '../../../../core/usecase/legacy_usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Parameters for ToggleTodo use case
class ToggleTodoParams {
  final String id;

  const ToggleTodoParams(this.id);
}

/// Use case for toggling todo completion status
class ToggleTodo implements LegacyUseCase<Todo, ToggleTodoParams> {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  @override
  Future<Todo> call(ToggleTodoParams params) {
    return repository.toggleTodo(params.id);
  }
}
