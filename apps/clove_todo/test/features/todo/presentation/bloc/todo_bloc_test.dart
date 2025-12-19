import 'package:bloc_test/bloc_test.dart';
import 'package:clove_todo/core/error/failures.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/add_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/get_todos.dart';
import 'package:clove_todo/features/todo/domain/usecases/toggle_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/update_todo.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockGetTodos extends Mock implements GetTodos {}

class _MockAddTodo extends Mock implements AddTodo {}

class _MockUpdateTodo extends Mock implements UpdateTodo {}

class _MockDeleteTodo extends Mock implements DeleteTodo {}

class _MockToggleTodo extends Mock implements ToggleTodo {}

void main() {
  late _MockGetTodos getTodos;
  late _MockAddTodo addTodo;
  late _MockUpdateTodo updateTodo;
  late _MockDeleteTodo deleteTodo;
  late _MockToggleTodo toggleTodo;

  final sampleTodo = Todo(
    id: '1',
    title: 'Sample',
    createdAt: DateTime.parse('2024-01-01'),
  );

  setUp(() {
    getTodos = _MockGetTodos();
    addTodo = _MockAddTodo();
    updateTodo = _MockUpdateTodo();
    deleteTodo = _MockDeleteTodo();
    toggleTodo = _MockToggleTodo();
  });

  blocTest<TodoBloc, TodoState>(
    'emits [Loading, Loaded] when LoadTodos succeeds',
    build: () {
      when(() => getTodos()).thenAnswer((_) async => [sampleTodo]);
      return TodoBloc(
        getTodos: getTodos,
        addTodo: addTodo,
        updateTodo: updateTodo,
        deleteTodo: deleteTodo,
        toggleTodo: toggleTodo,
      );
    },
    act: (bloc) => bloc.add(const LoadTodos()),
    expect: () => [
      const TodoLoading(),
      TodoLoaded([sampleTodo]),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'emits [Loading, Error] when LoadTodos throws Failure',
    build: () {
      when(() => getTodos()).thenThrow(const ServerFailure('fail'));
      return TodoBloc(
        getTodos: getTodos,
        addTodo: addTodo,
        updateTodo: updateTodo,
        deleteTodo: deleteTodo,
        toggleTodo: toggleTodo,
      );
    },
    act: (bloc) => bloc.add(const LoadTodos()),
    expect: () => [
      const TodoLoading(),
      const TodoError('fail'),
    ],
  );
}

