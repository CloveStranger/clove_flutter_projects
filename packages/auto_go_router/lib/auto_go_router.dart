class BuilderRoute {
  final String path;
  final Type page;
  final List<BuilderRoute> children;

  const BuilderRoute(this.path, this.page, {this.children = const []});
}

class GoRouterBuilderBridge {
  const GoRouterBuilderBridge({this.routes = const []});
  final List<BuilderRoute> routes;
}
