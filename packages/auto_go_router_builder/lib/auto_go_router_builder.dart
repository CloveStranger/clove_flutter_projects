import 'package:analyzer/dart/element/element.dart';
import 'package:auto_go_router/auto_go_router.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class GoRouterBuilderGenerator extends GeneratorForAnnotation<GoRouterBuilderBridge> {
  final StringBuffer _classesBuffer = StringBuffer();

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    _classesBuffer.clear();
    final buffer = StringBuffer();
    buffer.writeln("part of 'routes.dart';");
    final routes = annotation.peek('routes')?.listValue ?? [];
    for (final routeObj in routes) {
      _processRouteRecursive(ConstantReader(routeObj));
    }
    buffer.write(_classesBuffer.toString());
    return buffer.toString();
  }

  String _processRouteRecursive(ConstantReader routeReader) {
    final path = routeReader.peek('path')?.stringValue;
    final pageType = routeReader.peek('page')?.typeValue;
    if (path == null || pageType == null) return '';
    final classElement = pageType.element as ClassElement;
    final className = classElement.name;
    if (className == null) return '';
    final routeClassName = "${className}Route";
    final children = routeReader.peek('children')?.listValue ?? [];
    final childAnnotations = <String>[];
    for (final childObj in children) {
      final childAnnotationStr = _processRouteRecursive(ConstantReader(childObj));
      childAnnotations.add(childAnnotationStr);
    }
    String routesField = "";
    if (childAnnotations.isNotEmpty) {
      routesField = ", routes: [${childAnnotations.join(', ')}]";
    }
    _generateClassDefinition(routeClassName, className, classElement, path, routesField);
    return "TypedGoRoute<$routeClassName>(path: '$path'$routesField)";
  }

  void _generateClassDefinition(
    String routeClassName,
    String pageClassName,
    ClassElement pageElement,
    String path,
    String routesField,
  ) {
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
    final constrStr = constrParams.isEmpty ? "" : "{${constrParams.join(',')}}";
    _classesBuffer.writeln('''
      @TypedGoRoute<$routeClassName>(path: '$path'$routesField)
      class $routeClassName extends GoRouteData {
        const $routeClassName($constrStr);
        ${fields.join('\n')}

        @override
        Widget build(BuildContext context, GoRouterState state) {
          return $pageClassName(${callArgs.join(',')});
        }
      }
    ''');
  }
}

Builder goRouterBridgeBuilder(BuilderOptions options) {
  return LibraryBuilder(GoRouterBuilderGenerator(), generatedExtension: '.bridge.dart', header: '');
}
