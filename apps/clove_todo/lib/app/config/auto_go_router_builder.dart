import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class RouteDef {
  final String path;
  final Type page;
  // 🔥 新增：递归定义子路由
  final List<RouteDef> children;

  const RouteDef(
    this.path,
    this.page, {
    this.children = const [], // 默认为空
  });
}

class GoRouterBridge {
  const GoRouterBridge({this.routes = const []});
  final List<RouteDef> routes;
}

class BridgeGenerator extends GeneratorForAnnotation<GoRouterBridge> {
  final StringBuffer _classesBuffer = StringBuffer(); // 存所有的类定义

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    _classesBuffer.clear(); // 清空缓存

    // 1. 写入头部
    final buffer = StringBuffer();
    buffer.writeln("part of 'routes.dart';");

    // 2. 获取顶层路由列表
    final routes = annotation.peek('routes')?.listValue ?? [];

    for (final routeObj in routes) {
      _processRouteRecursive(ConstantReader(routeObj));
    }

    // 3. 输出所有积累的类定义
    buffer.write(_classesBuffer.toString());

    return buffer.toString();
  }

  /// 递归处理函数
  /// 返回值：生成的 @TypedGoRoute(...) 字符串，供父级引用
  String _processRouteRecursive(ConstantReader routeReader) {
    final path = routeReader.peek('path')?.stringValue;
    final pageType = routeReader.peek('page')?.typeValue;

    if (path == null || pageType == null) return '';

    final classElement = pageType.element as ClassElement;
    final className = classElement.name;

    if (className == null) return '';

    final routeClassName = "${className}Route"; // e.g. HomeRoute

    // --- A. 处理子路由 (递归入口) ---
    final children = routeReader.peek('children')?.listValue ?? [];
    final childAnnotations = <String>[];

    for (final childObj in children) {
      // 递归调用：获取子路由的注解字符串，同时这也会生成子路由的 Class 定义
      final childAnnotationStr = _processRouteRecursive(
        ConstantReader(childObj),
      );
      childAnnotations.add(childAnnotationStr);
    }

    // 组装 children 字符串: routes: [ TypedGoRoute<...>(...), ... ]
    String routesField = "";
    if (childAnnotations.isNotEmpty) {
      routesField = ", routes: [${childAnnotations.join(', ')}]";
    }

    // --- B. 生成当前的类定义 (存入全局 Buffer) ---
    // 注意：这里需要把生成的类存到 _classesBuffer，而不是返回
    // 因为类定义在文件中是平铺的
    _generateClassDefinition(
      routeClassName,
      className,
      classElement,
      path,
      routesField,
    );

    // --- C. 返回给父级的注解字符串 ---
    // 这部分是嵌在父级 @TypedGoRoute(routes: [...]) 里的
    return "TypedGoRoute<$routeClassName>(path: '$path'$routesField)";
  }

  /// 辅助：生成具体的 GoRouteData 类代码
  void _generateClassDefinition(
    String routeClassName,
    String pageClassName,
    ClassElement pageElement,
    String path,
    String routesField, // 这里的 routesField 只是为了标记，实际类定义上的注解在下面生成
  ) {
    // 构造函数参数分析逻辑（同之前）...
    final constructor = pageElement.unnamedConstructor;

    final params = constructor?.formalParameters ?? [];

    final constrParams = [];
    final fields = [];
    final callArgs = [];

    for (final p in params) {
      if (p.name == 'key') continue;
      fields.add('final ${p.type} ${p.name};');
      constrParams.add('${p.isRequired ? 'required ' : ''}this.${p.name}');
      callArgs.add('${p.name}: ${p.name}');
    }

    // 生成类代码
    _classesBuffer.writeln('''
      @TypedGoRoute<$routeClassName>(path: '$path'$routesField)
      class $routeClassName extends GoRouteData {
        const $routeClassName({${constrParams.join(',')}});
        ${fields.join('\n')}

        @override
        Widget build(BuildContext context, GoRouterState state) {
          return $pageClassName(${callArgs.join(',')});
        }
      }
    ''');
  }
}

// 🔥 核心修复点：这里必须有一个叫 bridgeBuilder 的函数
// 名字必须和 build.yaml 里的 builder_factories 一模一样
Builder bridgeBuilder(BuilderOptions options) {
  // 注意：如果你要生成独立文件 (例如 .bridge.dart)，建议用 LibraryBuilder
  // 如果你要生成 part of 文件 (.g.dart)，用 SharedPartBuilder

  return LibraryBuilder(
    BridgeGenerator(),
    generatedExtension: '.bridge.dart', // 输出后缀
    header: '', // 可选：控制文件头
  );
}
