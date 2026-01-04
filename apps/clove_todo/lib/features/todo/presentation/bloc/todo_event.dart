import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

/// Base class for all Todo events
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all todos
class LoadTodos extends TodoEvent {
  const LoadTodos();
}

/// Event to add a new todo
class AddTodoEvent extends TodoEvent {
  final Todo todo;

  const AddTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

/// Event to update an existing todo
class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  const UpdateTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

/// Event to delete a todo
class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to toggle todo completion status
class ToggleTodoEvent extends TodoEvent {
  final String id;

  const ToggleTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

