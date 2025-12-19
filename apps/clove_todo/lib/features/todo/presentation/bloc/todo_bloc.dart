import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clove_todo/core/error/failures.dart';
import 'package:clove_todo/features/todo/domain/usecases/add_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/get_todos.dart';
import 'package:clove_todo/features/todo/domain/usecases/toggle_todo.dart';
import 'package:clove_todo/features/todo/domain/usecases/update_todo.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_state.dart';

/// BLoC for managing Todo state
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodo toggleTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodo,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading());
    try {
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(_mapError(e)));
    }
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await addTodo(AddTodoParams(event.todo));
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(_mapError(e)));
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await updateTodo(UpdateTodoParams(event.todo));
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(_mapError(e)));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTodo(DeleteTodoParams(event.id));
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(_mapError(e)));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await toggleTodo(ToggleTodoParams(event.id));
      add(const LoadTodos());
    } catch (e) {
      emit(TodoError(_mapError(e)));
    }
  }

  String _mapError(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return 'Unexpected error: $error';
  }
}

