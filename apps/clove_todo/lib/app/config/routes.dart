import 'package:go_router/go_router.dart';
import '../../features/todo/presentation/pages/todo_page.dart';

/// Application routing configuration
class AppRoutes {
  static const String home = '/';
  static const String todoList = '/todos';
  static const String todoDetail = '/todos/detail';
  static const String todoAdd = '/todos/add';
  static const String todoEdit = '/todos/edit';

  /// Creates the router configuration
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: home,
      routes: [
        GoRoute(path: home, builder: (context, state) => const TodoPage()),
        GoRoute(path: todoList, builder: (context, state) => const TodoPage()),
      ],
    );
  }
}
