import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/device.dart';

part 'device_model.g.dart';

/// ObjectBox model for Device entity
@Entity()
@JsonSerializable()
class DeviceModel {
  @Id()
  int id = 0;

  @Unique()
  String deviceId;
  String name;
  String ipAddress;
  int port;

  @Property(type: PropertyType.byte)
  int type; // DeviceType enum as int

  bool isConnected;

  @Property(type: PropertyType.date)
  DateTime? lastSyncTime;

  String? publicKey;

  @Property(type: PropertyType.date)
  DateTime discoveredAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  DeviceModel({
    required this.deviceId,
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

  /// Convert from domain entity to model
  factory DeviceModel.fromEntity(Device device) {
    return DeviceModel(
      deviceId: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      type: device.type.index,
      isConnected: device.isConnected,
      lastSyncTime: device.lastSyncTime,
      publicKey: device.publicKey,
      discoveredAt: device.discoveredAt,
      updatedAt: device.updatedAt,
    );
  }

  /// Convert from model to domain entity
  Device toEntity() {
    return Device(
      id: deviceId,
      name: name,
      ipAddress: ipAddress,
      port: port,
      type: DeviceType.values[type],
      isConnected: isConnected,
      lastSyncTime: lastSyncTime,
      publicKey: publicKey,
      discoveredAt: discoveredAt,
      updatedAt: updatedAt,
    );
  }

  /// JSON serialization for sync
  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  @override
  String toString() {
    return 'DeviceModel(id: $id, deviceId: $deviceId, name: $name, ipAddress: $ipAddress, port: $port, type: $type, isConnected: $isConnected)';
  }
}
