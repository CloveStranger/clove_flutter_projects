import 'package:clove_todo/core/usecase/usecase.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';

/// Parameters for DeleteTodo use case
class DeleteTodoParams {
  final String id;

  const DeleteTodoParams(this.id);
}

/// Use case for deleting a todo
class DeleteTodo implements UseCase<void, DeleteTodoParams> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<void> call(DeleteTodoParams params) {
    return repository.deleteTodo(params.id);
  }
}

