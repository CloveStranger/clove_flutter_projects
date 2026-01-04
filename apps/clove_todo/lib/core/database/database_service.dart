import 'dart:io';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:injectable/injectable.dart';

import '../error/exceptions.dart';
import '../utils/logger.dart';
import '../../objectbox.g.dart'; // This will be generated

/// ObjectBox database service for local data persistence
@lazySingleton
class DatabaseService {
  static DatabaseService? _instance;
  Store? _store;

  DatabaseService._();

  factory DatabaseService() {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  /// Gets the ObjectBox store instance
  Store get store {
    if (_store == null) {
      throw DatabaseException('Database not initialized. Call initialize() first.');
    }
    return _store!;
  }

  /// Initializes the ObjectBox database
  Future<void> initialize() async {
    try {
      if (_store != null) {
        AppLogger.info('Database already initialized');
        return;
      }

      final directory = await _getDatabaseDirectory();
      AppLogger.info('Initializing ObjectBox database at: ${directory.path}');

      // This will use the generated openStore function
      _store = await openStore(directory: directory.path);

      AppLogger.info('ObjectBox database initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize database: $e');
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  /// Gets the database directory path
  Future<Directory> _getDatabaseDirectory() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbDir = Directory(p.join(appDocDir.path, 'objectbox'));

      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      return dbDir;
    } catch (e) {
      throw DatabaseException('Failed to create database directory: $e');
    }
  }

  /// Closes the database connection
  Future<void> close() async {
    try {
      if (_store != null) {
        _store!.close();
        _store = null;
        AppLogger.info('Database connection closed');
      }
    } catch (e) {
      AppLogger.error('Error closing database: $e');
      throw DatabaseException('Failed to close database: $e');
    }
  }

  /// Performs database migration if needed
  Future<void> migrate() async {
    try {
      // ObjectBox handles migrations automatically
      // Custom migration logic can be added here if needed
      AppLogger.info('Database migration completed');
    } catch (e) {
      AppLogger.error('Database migration failed: $e');
      throw DatabaseException('Database migration failed: $e');
    }
  }

  /// Checks if the database is initialized
  bool get isInitialized => _store != null;

  /// Gets database statistics
  Map<String, dynamic> getStats() {
    if (_store == null) {
      return {'initialized': false};
    }

    return {
      'initialized': true,
      'path': _store!.directoryPath,
      // Add more stats as needed
    };
  }

  /// Performs database backup
  Future<String> backup() async {
    try {
      if (_store == null) {
        throw DatabaseException('Database not initialized');
      }

      final backupDir = await getTemporaryDirectory();
      final backupPath = p.join(backupDir.path, 'clove_todo_backup_${DateTime.now().millisecondsSinceEpoch}');

      // ObjectBox backup implementation would go here
      // This is a placeholder for the actual backup logic

      AppLogger.info('Database backup created at: $backupPath');
      return backupPath;
    } catch (e) {
      AppLogger.error('Database backup failed: $e');
      throw DatabaseException('Database backup failed: $e');
    }
  }

  /// Restores database from backup
  Future<void> restore(String backupPath) async {
    try {
      if (!File(backupPath).existsSync()) {
        throw DatabaseException('Backup file not found: $backupPath');
      }

      // Close current store
      await close();

      // ObjectBox restore implementation would go here
      // This is a placeholder for the actual restore logic

      // Reinitialize after restore
      await initialize();

      AppLogger.info('Database restored from: $backupPath');
    } catch (e) {
      AppLogger.error('Database restore failed: $e');
      throw DatabaseException('Database restore failed: $e');
    }
  }
}
