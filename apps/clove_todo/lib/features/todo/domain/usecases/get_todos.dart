import '../../../../core/usecase/legacy_usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos
class GetTodos implements LegacyUseCaseNoParams<List<Todo>> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}
