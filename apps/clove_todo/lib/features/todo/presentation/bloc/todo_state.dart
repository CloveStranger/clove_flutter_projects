import 'package:equatable/equatable.dart';
import 'package:clove_todo/features/todo/domain/entities/todo.dart';

/// Base class for all Todo states
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TodoInitial extends TodoState {
  const TodoInitial();
}

/// Loading state
class TodoLoading extends TodoState {
  const TodoLoading();
}

/// Loaded state with todos
class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

/// Error state
class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}

