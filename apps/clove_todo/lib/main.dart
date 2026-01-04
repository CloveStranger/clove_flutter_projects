import 'package:flutter/material.dart';
import 'app/app.dart';
import 'injection/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.configureDependencies();

  runApp(const App());
}
