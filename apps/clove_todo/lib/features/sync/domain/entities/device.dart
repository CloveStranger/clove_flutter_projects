import 'package:equatable/equatable.dart';

/// Types of devices that can participate in sync
enum DeviceType {
  mobile,
  desktop,
  tablet;

  String get displayName {
    switch (this) {
      case DeviceType.mobile:
        return 'Mobile';
      case DeviceType.desktop:
        return 'Desktop';
      case DeviceType.tablet:
        return 'Tablet';
    }
  }
}

/// Domain entity representing a device in the sync network
class Device extends Equatable {
  final String id;
  final String name;
  final String ipAddress;
  final int port;
  final DeviceType type;
  final bool isConnected;
  final DateTime? lastSyncTime;
  final String? publicKey;
  final DateTime discoveredAt;
  final DateTime updatedAt;

  const Device({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.type,
    required this.discoveredAt,
    required this.updatedAt,
    this.isConnected = false,
    this.lastSyncTime,
    this.publicKey,
  });

  /// Create a new Device with validation
  factory Device.create({
    required String id,
    required String name,
    required String ipAddress,
    required int port,
    required DeviceType type,
    String? publicKey,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError('Device ID cannot be empty');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Device name cannot be empty');
    }
    if (ipAddress.trim().isEmpty) {
      throw ArgumentError('IP address cannot be empty');
    }
    if (port <= 0 || port > 65535) {
      throw ArgumentError('Port must be between 1 and 65535');
    }

    final now = DateTime.now();
    return Device(
      id: id,
      name: name.trim(),
      ipAddress: ipAddress.trim(),
      port: port,
      type: type,
      publicKey: publicKey,
      discoveredAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with updated fields
  Device copyWith({
    String? id,
    String? name,
    String? ipAddress,
    int? port,
    DeviceType? type,
    bool? isConnected,
    DateTime? lastSyncTime,
    String? publicKey,
    DateTime? discoveredAt,
    DateTime? updatedAt,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      type: type ?? this.type,
      isConnected: isConnected ?? this.isConnected,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      publicKey: publicKey ?? this.publicKey,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Mark device as connected
  Device markAsConnected() {
    return copyWith(isConnected: true);
  }

  /// Mark device as disconnected
  Device markAsDisconnected() {
    return copyWith(isConnected: false);
  }

  /// Update last sync time
  Device updateLastSyncTime([DateTime? syncTime]) {
    return copyWith(lastSyncTime: syncTime ?? DateTime.now());
  }

  /// Get device endpoint URL
  String get endpoint => 'http://$ipAddress:$port';

  /// Check if device is reachable (connected and recently seen)
  bool get isReachable {
    if (!isConnected) return false;
    if (lastSyncTime == null) return true; // Never synced, assume reachable

    final now = DateTime.now();
    final timeSinceLastSync = now.difference(lastSyncTime!);
    return timeSinceLastSync.inMinutes < 5; // Consider unreachable after 5 minutes
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ipAddress,
    port,
    type,
    isConnected,
    lastSyncTime,
    publicKey,
    discoveredAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Device(id: $id, name: $name, ipAddress: $ipAddress, port: $port, type: $type, isConnected: $isConnected)';
  }
}
