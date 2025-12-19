# Flutter Clean Architecture Development Specification

This document outlines the Clean Architecture guidelines for the `clove_todo` project. The goal is to ensure separation of concerns, testability, and maintainability.

## 1. Architecture Overview

The project is divided into three main layers:

1.  **Domain Layer** (Inner Layer)
2.  **Data Layer** (Middle Layer)
3.  **Presentation Layer** (Outer Layer)

Dependencies flow strictly **inwards**. The Domain layer knows nothing about Data or Presentation. Data knows only about Domain. Presentation knows about Domain (and potentially DI/Service Locator).

## 2. Layer Details

### 2.1 Domain Layer (`lib/features/<feature>/domain`)

This is the core of the application. It contains the business logic and is independent of any external libraries (Flutter, HTTP, DB).

- **Entities:** Pure Dart classes representing the core business objects. They should not extend generic models or contain JSON serialization logic.
- **Repositories (Interfaces):** Abstract classes defining the contract for data operations.
- **Use Cases:** Classes encapsulating specific business rules. Each Use Case should have a single responsibility (e.g., `GetTodos`, `AddTodo`).

**Structure:**

```
domain/
  ├── entities/
  │   └── todo.dart
  ├── repositories/
  │   └── todo_repository.dart
  └── usecases/
      ├── get_todos.dart
      └── add_todo.dart
```

### 2.2 Data Layer (`lib/features/<feature>/data`)

This layer handles data retrieval and persistence. It implements the interfaces defined in the Domain layer.

- **Models:** Data Transfer Objects (DTOs) that extend Entities. They handle JSON serialization/deserialization (`fromJson`, `toJson`) and mapping to/from DB schemas.
- **Data Sources:**
  - `RemoteDataSource`: Handles API calls (Dio/Http).
  - `LocalDataSource`: Handles local database/cache (Hive/Sqflite/SharedPreferences).
- **Repositories (Implementation):** Implements the Domain Repository interface. It coordinates data from Data Sources and returns `Future<Entity>` to the Domain layer, throwing specific Exceptions on failure.

**Structure:**

```
data/
  ├── datasources/
  │   ├── todo_remote_data_source.dart
  │   └── todo_local_data_source.dart
  ├── models/
  │   └── todo_model.dart
  └── repositories/
      └── todo_repository_impl.dart
```

### 2.3 Presentation Layer (`lib/features/<feature>/presentation`)

This layer is responsible for showing the UI and handling user input.

- **Pages/Screens:** Top-level widgets representing a full screen.
- **Widgets:** Reusable UI components.
- **State Management (Bloc/Cubit/Provider):** Handles the state of the view. It calls Use Cases from the Domain layer and maps the results to UI states.

**Structure:**

```
presentation/
  ├── bloc/
  │   ├── todo_bloc.dart
  │   ├── todo_event.dart
  │   └── todo_state.dart
  ├── pages/
  │   └── todo_page.dart
  └── widgets/
      └── todo_item_tile.dart
```

## 3. Core Layer (`lib/core`)

The Core layer contains shared utilities and infrastructure that are used across multiple features.

**Structure:**

```
core/
  ├── error/              # Error handling
  │   ├── failures.dart   # Failure classes (ServerFailure, CacheFailure, etc.)
  │   └── exceptions.dart # Exception classes
  ├── network/            # Network infrastructure
  │   ├── api_client.dart # Dio/Http client wrapper
  │   └── network_info.dart # Network connectivity checker
  ├── usecase/            # Base UseCase class (optional)
  │   └── usecase.dart
  └── utils/              # Shared utilities
      ├── constants.dart
      └── validators.dart
```

**Key Components:**

- **Failures:** Abstract base class for all failures. Subclasses: `ServerFailure`, `CacheFailure`, `NetworkFailure`, `ValidationFailure`.
- **Network Info:** Interface to check network connectivity (used by Repositories to decide remote vs local data).
- **API Client:** Configured HTTP client (Dio) with interceptors, error handling, and base URL.

## 4. App Layer (`lib/app`)

This layer contains application-wide configuration and entry points. It separates global app settings from the core utilities and feature modules.

**Structure:**

```
app/
  ├── config/             # App-wide configuration
  │   └── routes.dart     # Navigation routing (GoRouter + GoRouterBuilder)
  ├── theme/              # App styling
  │   └── app_theme.dart
  └── app.dart            # Root App Widget (MaterialApp)
```

**Routing Strategy:**
We use `go_router` combined with `go_router_builder` to define type-safe routes. This approach decouples the routing configuration from individual features. Features do not need to know about string paths; they simply navigate using the generated type-safe route classes. This reduces coupling and eliminates "magic string" errors.

## 5. General Rules

1.  **Dependency Injection:** Use `get_it` and `injectable` (or similar) for dependency injection.
2.  **Error Handling:** Use standard Dart `try-catch` blocks.
    - **Data Sources:** Throw raw exceptions (e.g., `DioException`).
    - **Repositories:** Catch raw exceptions and rethrow them as domain-specific `Failure` exceptions (or custom `AppException`).
    - **Use Cases:** Propagate exceptions to the Presentation layer.
    - **Presentation:** Catch exceptions in the BLoC/State management layer and map them to Error states.
3.  **Folder Structure:** Organize code by **Feature**, then by **Layer**.
    ```
    lib/
      ├── app/            # Global app config, theme, and root widget
      ├── core/           # Shared utilities, error types, network clients
      ├── features/
      │   ├── todo/
      │   │   ├── data/
      │   │   ├── domain/
      │   │   └── presentation/
      │   └── auth/
      │       ...
      ├── injection/      # Dependency injection setup
      │   └── injection_container.dart
      └── main.dart       # Entry point calling App
    ```
4.  **Testing:**
    - **Domain:** Unit tests for Use Cases (mocking Repositories).
    - **Data:** Unit tests for Repository implementations (mocking Data Sources) and Data Sources (mocking Clients).
    - **Presentation:** Widget tests and BLoC tests.

## 6. Naming Conventions

- **Classes:** UpperCamelCase (e.g., `TodoRepository`)
- **Files:** snake_case (e.g., `todo_repository.dart`)
- **Variables/Methods:** lowerCamelCase (e.g., `getTodos`)
- **Constants:** lowerCamelCase (preferred) or SCREAMING_SNAKE_CASE.

## 7. Libraries (Recommended)

- `flutter_bloc`: State management.
- `go_router` + `go_router_builder`: Navigation and routing (Type-safe).
- `get_it` + `injectable`: Dependency Injection.
- `dio`: HTTP client.
- `freezed` + `json_serializable`: Immutable data classes and JSON serialization.

## 8. Testing Guidelines & Coverage Standards

To ensure robustness, each layer of the Clean Architecture must adhere to specific testing strategies and code coverage thresholds.

### 8.1 Domain Layer

- **Scope**: Use Cases and Entities.
- **Test Type**: Unit Tests.
- **Strategy**:
  - Test all business rules and edge cases.
  - Mock Repositories to isolate Use Cases.
  - Ensure Entities behave as expected (if they have logic).
- **Coverage Target**: **100%**. Use Cases contain pure business logic and must be fully verified.

### 8.2 Data Layer

- **Scope**: Repositories, Data Sources, and Models.
- **Test Type**: Unit Tests.
- **Strategy**:
  - **Models**: Verify `fromJson`/`toJson` conversions and strict type mapping.
  - **Repositories**: Verify correct interaction with Data Sources and proper error mapping (Exception -> Failure).
  - **Data Sources**: Mock external clients (Dio, Hive) to verify request formation and response parsing.
- **Coverage Target**: **≥ 80%**. Focus on mapping logic and error handling paths.

### 8.3 Presentation Layer (State Management)

- **Scope**: BLoC / Cubit / ViewModels.
- **Test Type**: Unit Tests (bloc_test).
- **Strategy**:
  - Verify state changes in response to events.
  - Mock Use Cases to simulate success and failure scenarios.
- **Coverage Target**: **≥ 90%**. Application state logic is critical for UX.

### 8.4 Presentation Layer (UI Widgets)

- **Scope**: Pages and reusable Widgets.
- **Test Type**: Widget Tests.
- **Strategy**:
  - Verify widget rendering for different states (Loading, Success, Error).
  - Test user interactions (taps, text input).
  - Use "Golden Tests" for pixel-perfect visual regression checks (optional but recommended).
- **Coverage Target**: **≥ 70%**. Focus on critical user flows and complex UI components.

### 8.5 Core & Shared

- **Scope**: Utility functions, Extensions, Parsers.
- **Test Type**: Unit Tests.
- **Strategy**: Test all input/output permutations for utility functions.
- **Coverage Target**: **≥ 90%**.

### 8.6 Execution

Run tests with coverage to verify standards:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 8.7 Test Folder Structure

The `test/` directory should strictly mirror the structure of the `lib/` directory to ensure clarity and discoverability.

```
test/
  ├── app/                    # Tests for App layer
  │   └── config/
  │       └── routes_test.dart
  ├── core/                   # Tests for Core layer
  │   └── utils/
  │       └── validators_test.dart
  ├── features/               # Tests for Features
  │   └── todo/
  │       ├── data/
  │       │   ├── datasources/
  │       │   ├── models/
  │       │   └── repositories/
  │       ├── domain/
  │       │   └── usecases/
  │       └── presentation/
  │           ├── bloc/
  │           └── widgets/
  └── helpers/                # Shared test helpers, mocks, fixtures
      ├── fixtures/           # JSON files, dummy data
      └── test_helper.dart    # Mock generation setup
```

## 9. Common Pitfalls & Anti-Patterns

### ❌ Don't:

1.  **Import Flutter/Dart IO in Domain Layer**: Domain should be pure Dart.
2.  **Return Models from Repository to Domain**: Always convert Models to Entities.
3.  **Put Business Logic in BLoC**: Business logic belongs in Use Cases.
4.  **Create God Objects**: Keep classes focused and single-responsibility.
5.  **Swallow Errors**: Always catch exceptions and map them to user-friendly Failures/States.
6.  **Use Concrete Classes in Dependencies**: Use interfaces/abstract classes for DI.
7.  **Mix Data Sources**: Keep Remote and Local Data Sources separate.
8.  **Put JSON Logic in Entities**: Entities are pure business objects.

### ✅ Do:

1.  **Use Interfaces**: Define contracts with abstract classes.
2.  **Convert at Boundaries**: Models ↔ Entities at Repository layer only.
3.  **Handle All States**: Loading, Success, Error states in UI.
4.  **Test in Isolation**: Mock dependencies, test one thing at a time.
5.  **Use Freezed**: For immutable data classes and unions.
6.  **Validate Early**: Validate input in Use Cases or Data Sources.
7.  **Document Complex Logic**: Add comments for non-obvious business rules.

## 10. Code Examples

### 10.1 Entity (Domain Layer)

```dart
// lib/features/todo/domain/entities/todo.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required bool isCompleted,
    DateTime? dueDate,
  }) = _Todo;
}
```

### 10.2 Repository Interface (Domain Layer)

```dart
// lib/features/todo/domain/repositories/todo_repository.dart
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> addTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
```

### 10.3 Use Case (Domain Layer)

```dart
// lib/features/todo/domain/usecases/get_todos.dart
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<Todo>> call() async {
    return await repository.getTodos();
  }
}
```

### 10.4 Model (Data Layer)

```dart
// lib/features/todo/data/models/todo_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/todo.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class TodoModel with _$TodoModel {
  const factory TodoModel({
    required String id,
    required String title,
    @JsonKey(name: 'is_completed') required bool isCompleted,
    @JsonKey(name: 'due_date') DateTime? dueDate,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  // Convert Model to Entity
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      isCompleted: isCompleted,
      dueDate: dueDate,
    );
  }
}
```

### 10.5 Repository Implementation (Data Layer)

```dart
// lib/features/todo/data/repositories/todo_repository_impl.dart
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_data_source.dart';
import '../datasources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Todo>> getTodos() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTodos = await remoteDataSource.getTodos();
        await localDataSource.cacheTodos(remoteTodos);
        return remoteTodos.map((model) => model.toEntity()).toList();
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    } else {
      try {
        final localTodos = await localDataSource.getCachedTodos();
        return localTodos.map((model) => model.toEntity()).toList();
      } catch (e) {
        throw CacheFailure(e.toString());
      }
    }
  }

  // ... other methods
}
```

### 10.6 BLoC (Presentation Layer)

```dart
// lib/features/todo/presentation/bloc/todo_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_todos.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;

  TodoBloc({required this.getTodos}) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
```
