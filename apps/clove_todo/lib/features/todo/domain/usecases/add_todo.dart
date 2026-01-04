import '../../../../core/usecase/legacy_usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Parameters for AddTodo use case
class AddTodoParams {
  final Todo todo;

  const AddTodoParams(this.todo);
}

/// Use case for adding a new todo
class AddTodo implements LegacyUseCase<Todo, AddTodoParams> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<Todo> call(AddTodoParams params) {
    return repository.addTodo(params.todo);
  }
}
