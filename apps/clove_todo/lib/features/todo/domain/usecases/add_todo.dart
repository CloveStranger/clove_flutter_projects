import 'package:clove_todo/core/usecase/usecase.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';

/// Parameters for AddTodo use case
class AddTodoParams {
  final Todo todo;

  const AddTodoParams(this.todo);
}

/// Use case for adding a new todo
class AddTodo implements UseCase<Todo, AddTodoParams> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<Todo> call(AddTodoParams params) {
    return repository.addTodo(params.todo);
  }
}

