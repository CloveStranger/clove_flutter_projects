import 'package:clove_todo/core/usecase/usecase.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';

/// Use case for getting all todos
class GetTodos implements UseCaseNoParams<List<Todo>> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}

