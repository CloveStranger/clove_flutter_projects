import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clove_todo/app/config/routes.dart';
import 'package:clove_todo/app/theme/app_theme.dart';
import 'package:clove_todo/features/todo/presentation/pages/todo_page.dart';

final _router = GoRouter(
  initialLocation: AppRoutes.todoList,
  routes: [
    GoRoute(
      path: AppRoutes.todoList,
      name: 'todoList',
      builder: (context, state) => const TodoPage(),
    ),
  ],
);

/// Root application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clove Todo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
