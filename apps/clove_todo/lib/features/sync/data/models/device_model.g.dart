// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String,
      ipAddress: json['ipAddress'] as String,
      port: (json['port'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isConnected: json['isConnected'] as bool? ?? false,
      lastSyncTime: json['lastSyncTime'] == null
          ? null
          : DateTime.parse(json['lastSyncTime'] as String),
      publicKey: json['publicKey'] as String?,
    )..id = (json['id'] as num).toInt();

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'type': instance.type,
      'isConnected': instance.isConnected,
      'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
      'publicKey': instance.publicKey,
      'discoveredAt': instance.discoveredAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
