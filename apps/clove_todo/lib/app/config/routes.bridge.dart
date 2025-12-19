// dart format width=80

// **************************************************************************
// GoRouterBuilderGenerator
// **************************************************************************

part of 'routes.dart';

@TypedGoRoute<TodoPageRoute>(path: '/todos')
class TodoPageRoute extends GoRouteData {
  const TodoPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TodoPage();
  }
}
