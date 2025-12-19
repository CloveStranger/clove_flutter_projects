
// **************************************************************************
// BridgeGenerator
// **************************************************************************

part of 'routes.dart';
      @TypedGoRoute<TodoPageRoute>(path: '/todos')
      class TodoPageRoute extends GoRouteData {
        const TodoPageRoute({});
        

        @override
        Widget build(BuildContext context, GoRouterState state) {
          return TodoPage();
        }
      }
