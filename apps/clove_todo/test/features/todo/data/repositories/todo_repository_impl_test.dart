import 'package:clove_todo/core/error/exceptions.dart';
import 'package:clove_todo/core/error/failures.dart';
import 'package:clove_todo/core/network/network_info.dart';
import 'package:clove_todo/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:clove_todo/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:clove_todo/features/todo/data/models/todo_model.dart';
import 'package:clove_todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements TodoRemoteDataSource {}

class _MockLocal extends Mock implements TodoLocalDataSource {}

class _MockNetworkInfo extends Mock implements NetworkInfo {}

class _TodoModelFake extends Fake implements TodoModel {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late _MockNetworkInfo networkInfo;
  late TodoRepositoryImpl repository;

  final sampleTodos = [TodoModel(id: '1', title: 'Sample', createdAt: DateTime.parse('2024-01-01'))];

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    networkInfo = _MockNetworkInfo();
    repository = TodoRepositoryImpl(remoteDataSource: remote, localDataSource: local, networkInfo: networkInfo);
  });

  setUpAll(() {
    registerFallbackValue(_TodoModelFake());
  });

  group('getTodos', () {
    test('online: should return remote todos and cache them', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remote.getTodos()).thenAnswer((_) async => sampleTodos);
      when(() => local.cacheTodos(sampleTodos)).thenAnswer((_) async {});

      final result = await repository.getTodos();

      expect(result.length, 1);
      expect(result.first.title, 'Sample');
      verify(() => remote.getTodos()).called(1);
      verify(() => local.cacheTodos(sampleTodos)).called(1);
    });

    test('offline: should return cached todos', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => local.getTodos()).thenAnswer((_) async => sampleTodos);

      final result = await repository.getTodos();

      expect(result.first.id, '1');
      verifyNever(() => remote.getTodos());
      verify(() => local.getTodos()).called(1);
    });

    test('should map cache exception to CacheFailure', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => local.getTodos()).thenThrow(const CacheException('cache fail'));

      expect(() => repository.getTodos(), throwsA(isA<CacheFailure>()));
    });
  });

  group('getTodoById', () {
    test('offline: returns cached entity', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => local.getTodoById('1')).thenAnswer((_) async => sampleTodos.first);

      final result = await repository.getTodoById('1');

      expect(result.id, '1');
      verify(() => local.getTodoById('1')).called(1);
      verifyNever(() => remote.getTodoById(any()));
    });

    test('throws CacheFailure when not found offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => local.getTodoById('missing')).thenAnswer((_) async => null);

      expect(() => repository.getTodoById('missing'), throwsA(isA<CacheFailure>()));
    });
  });

  group('addTodo', () {
    final model = sampleTodos.first;
    test('online: should sync remote and return entity', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => local.addTodo(any())).thenAnswer((_) async {});
      when(() => remote.addTodo(any())).thenAnswer((_) async => model);
      when(() => local.updateTodo(any())).thenAnswer((_) async {});

      final result = await repository.addTodo(model.toEntity());

      expect(result.id, model.id);
      verify(() => remote.addTodo(any())).called(1);
      verify(() => local.updateTodo(any())).called(1);
    });

    test('offline: should return cached entity', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => local.addTodo(any())).thenAnswer((_) async {});

      final result = await repository.addTodo(model.toEntity());

      expect(result.id, model.id);
      verifyNever(() => remote.addTodo(model));
    });
  });
}
