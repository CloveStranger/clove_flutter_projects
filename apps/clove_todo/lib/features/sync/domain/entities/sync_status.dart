import 'package:equatable/equatable.dart';

/// Status of synchronization operations
enum SyncState {
  idle,
  discovering,
  connecting,
  syncing,
  completed,
  failed;

  String get displayName {
    switch (this) {
      case SyncState.idle:
        return 'Idle';
      case SyncState.discovering:
        return 'Discovering Devices';
      case SyncState.connecting:
        return 'Connecting';
      case SyncState.syncing:
        return 'Syncing';
      case SyncState.completed:
        return 'Completed';
      case SyncState.failed:
        return 'Failed';
    }
  }
}

/// Value object representing the current sync status
class SyncStatus extends Equatable {
  final SyncState state;
  final String? message;
  final DateTime timestamp;
  final int? progress; // 0-100 percentage
  final String? deviceId; // Device currently being synced with
  final Map<String, dynamic>? metadata;

  const SyncStatus({
    required this.state,
    required this.timestamp,
    this.message,
    this.progress,
    this.deviceId,
    this.metadata,
  });

  /// Create a new sync status
  factory SyncStatus.create({
    required SyncState state,
    String? message,
    int? progress,
    String? deviceId,
    Map<String, dynamic>? metadata,
  }) {
    if (progress != null && (progress < 0 || progress > 100)) {
      throw ArgumentError('Progress must be between 0 and 100');
    }

    return SyncStatus(
      state: state,
      message: message,
      progress: progress,
      deviceId: deviceId,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create idle status
  factory SyncStatus.idle() {
    return SyncStatus.create(state: SyncState.idle);
  }

  /// Create discovering status
  factory SyncStatus.discovering() {
    return SyncStatus.create(state: SyncState.discovering, message: 'Searching for devices...');
  }

  /// Create connecting status
  factory SyncStatus.connecting(String deviceId) {
    return SyncStatus.create(state: SyncState.connecting, message: 'Connecting to device...', deviceId: deviceId);
  }

  /// Create syncing status
  factory SyncStatus.syncing(String deviceId, {int? progress}) {
    return SyncStatus.create(
      state: SyncState.syncing,
      message: 'Synchronizing data...',
      deviceId: deviceId,
      progress: progress,
    );
  }

  /// Create completed status
  factory SyncStatus.completed(String deviceId) {
    return SyncStatus.create(
      state: SyncState.completed,
      message: 'Sync completed successfully',
      deviceId: deviceId,
      progress: 100,
    );
  }

  /// Create failed status
  factory SyncStatus.failed(String message, {String? deviceId}) {
    return SyncStatus.create(state: SyncState.failed, message: message, deviceId: deviceId);
  }

  /// Create a copy with updated fields
  SyncStatus copyWith({
    SyncState? state,
    String? message,
    DateTime? timestamp,
    int? progress,
    String? deviceId,
    Map<String, dynamic>? metadata,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      progress: progress ?? this.progress,
      deviceId: deviceId ?? this.deviceId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if sync is currently active
  bool get isActive {
    return state == SyncState.discovering || state == SyncState.connecting || state == SyncState.syncing;
  }

  /// Check if sync completed successfully
  bool get isCompleted => state == SyncState.completed;

  /// Check if sync failed
  bool get isFailed => state == SyncState.failed;

  /// Check if sync is idle
  bool get isIdle => state == SyncState.idle;

  @override
  List<Object?> get props => [state, message, timestamp, progress, deviceId, metadata];

  @override
  String toString() {
    return 'SyncStatus(state: $state, message: $message, progress: $progress, deviceId: $deviceId)';
  }
}
