import '../../../../core/usecase/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos
class GetTodos implements UseCaseNoParams<List<Todo>> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}

