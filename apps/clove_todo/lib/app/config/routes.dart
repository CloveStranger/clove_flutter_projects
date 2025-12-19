import 'package:auto_go_router/auto_go_router.dart';
import 'package:clove_todo/features/todo/presentation/pages/todo_page.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

part 'routes.bridge.dart';

/// Application routing configuration
class AppRoutes {
  static const String home = '/';
  static const String todoList = '/todos';
  static const String todoDetail = '/todos/detail';
  static const String todoAdd = '/todos/add';
  static const String todoEdit = '/todos/edit';
}

@GoRouterBuilderBridge(routes: [BuilderRoute('/todos', TodoPage)])
class UserRoute {
  const UserRoute();
}
