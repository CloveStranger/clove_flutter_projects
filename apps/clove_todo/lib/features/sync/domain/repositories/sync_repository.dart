import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/entities.dart';

/// Repository interface for synchronization operations
abstract class SyncRepository {
  /// Device Discovery
  Future<Either<Failure, List<Device>>> discoverDevices();
  Future<Either<Failure, Device>> getDeviceById(String id);
  Future<Either<Failure, List<Device>>> getKnownDevices();
  Future<Either<Failure, Device>> addDevice(Device device);
  Future<Either<Failure, Device>> updateDevice(Device device);
  Future<Either<Failure, void>> removeDevice(String id);

  /// Connection Management
  Future<Either<Failure, bool>> connectToDevice(String deviceId);
  Future<Either<Failure, void>> disconnectFromDevice(String deviceId);
  Future<Either<Failure, bool>> isDeviceReachable(String deviceId);

  /// Synchronization Operations
  Future<Either<Failure, void>> syncWithDevice(String deviceId);
  Future<Either<Failure, void>> syncWithAllDevices();
  Future<Either<Failure, SyncStatus>> getSyncStatus();
  Future<Either<Failure, void>> cancelSync();

  /// Conflict Resolution
  Future<Either<Failure, List<ConflictResolution>>> getPendingConflicts();
  Future<Either<Failure, ConflictResolution>> getConflictById(String id);
  Future<Either<Failure, ConflictResolution>> resolveConflict(ConflictResolution resolution);
  Future<Either<Failure, void>> resolveAllConflicts(ConflictResolutionType defaultStrategy);

  /// Offline Change Management
  Future<Either<Failure, void>> queueOfflineChanges(Map<String, dynamic> changes);
  Future<Either<Failure, List<Map<String, dynamic>>>> getOfflineChanges();
  Future<Either<Failure, void>> clearOfflineChanges();

  /// Sync Settings
  Future<Either<Failure, bool>> isSyncEnabled();
  Future<Either<Failure, void>> enableSync();
  Future<Either<Failure, void>> disableSync();
  Future<Either<Failure, int>> getSyncInterval(); // in minutes
  Future<Either<Failure, void>> setSyncInterval(int minutes);

  /// Data Integrity
  Future<Either<Failure, bool>> validateDataIntegrity();
  Future<Either<Failure, Map<String, String>>> generateDataHashes();
  Future<Either<Failure, bool>> compareDataHashes(Map<String, String> remoteHashes);

  /// Sync History and Statistics
  Future<Either<Failure, List<Map<String, dynamic>>>> getSyncHistory();
  Future<Either<Failure, Map<String, int>>> getSyncStatistics();
  Future<Either<Failure, DateTime?>> getLastSyncTime();
  Future<Either<Failure, void>> recordSyncEvent({
    required String deviceId,
    required String eventType,
    required bool success,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  });

  /// Network Information
  Future<Either<Failure, String>> getLocalIPAddress();
  Future<Either<Failure, int>> getLocalPort();
  Future<Either<Failure, bool>> isNetworkAvailable();

  /// Backup and Restore for Sync
  Future<Either<Failure, Map<String, dynamic>>> exportSyncData();
  Future<Either<Failure, void>> importSyncData(Map<String, dynamic> data);

  /// Stream-based operations for real-time updates
  Stream<SyncStatus> watchSyncStatus();
  Stream<List<Device>> watchDevices();
  Stream<List<ConflictResolution>> watchConflicts();
}
