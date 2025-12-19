import 'package:clove_todo/core/usecase/usecase.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';

/// Parameters for UpdateTodo use case
class UpdateTodoParams {
  final Todo todo;

  const UpdateTodoParams(this.todo);
}

/// Use case for updating an existing todo
class UpdateTodo implements UseCase<Todo, UpdateTodoParams> {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  @override
  Future<Todo> call(UpdateTodoParams params) {
    return repository.updateTodo(params.todo);
  }
}

