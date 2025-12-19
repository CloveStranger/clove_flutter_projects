import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clove_todo/app/app.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clove_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:clove_todo/injection/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<TodoBloc>()..add(const LoadTodos())),
      ],
      child: const App(),
    ),
  );
}
