import 'package:clove_todo/features/todo/domain/entities/todo.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_state.dart';
import 'package:clove_todo/features/todo/presentation/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoBloc extends Mock implements TodoBloc {}

class _FakeTodoState extends Fake implements TodoState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeTodoState());
  });

  testWidgets('shows empty state when no todos', (tester) async {
    final bloc = _MockTodoBloc();
    when(() => bloc.state).thenReturn(const TodoLoaded([]));
    when(() => bloc.stream).thenAnswer((_) => const Stream<TodoState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TodoBloc>.value(
          value: bloc,
          child: const TodoPage(),
        ),
      ),
    );

    expect(find.text('No todos yet'), findsOneWidget);
  });

  testWidgets('shows todo list items', (tester) async {
    final bloc = _MockTodoBloc();
    when(() => bloc.state).thenReturn(
      TodoLoaded([
        Todo(
          id: '1',
          title: 'Read spec',
          createdAt: DateTime.parse('2024-01-01'),
        ),
      ]),
    );
    when(() => bloc.stream).thenAnswer((_) => Stream.value(bloc.state));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TodoBloc>.value(
          value: bloc,
          child: const TodoPage(),
        ),
      ),
    );

    expect(find.text('Read spec'), findsOneWidget);
  });
}

