import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:clove_todo/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late _MockTodoRepository repository;
  late GetTodos usecase;

  setUp(() {
    repository = _MockTodoRepository();
    usecase = GetTodos(repository);
  });

  test('should return todos from repository', () async {
    final todos = [Todo(id: '1', title: 'Test', createdAt: DateTime.parse('2024-01-01'))];
    when(() => repository.getTodos()).thenAnswer((_) async => todos);

    final result = await usecase();

    expect(result, todos);
    verify(() => repository.getTodos()).called(1);
  });
}
