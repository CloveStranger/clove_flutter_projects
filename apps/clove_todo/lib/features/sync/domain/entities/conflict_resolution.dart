import 'package:equatable/equatable.dart';

/// Types of conflict resolution strategies
enum ConflictResolutionType {
  useLocal,
  useRemote,
  merge,
  manual;

  String get displayName {
    switch (this) {
      case ConflictResolutionType.useLocal:
        return 'Use Local Version';
      case ConflictResolutionType.useRemote:
        return 'Use Remote Version';
      case ConflictResolutionType.merge:
        return 'Merge Changes';
      case ConflictResolutionType.manual:
        return 'Manual Resolution';
    }
  }
}

/// Entity representing a conflict resolution decision
class ConflictResolution extends Equatable {
  final String id;
  final String entityId; // ID of the conflicting entity (schedule, reminder, etc.)
  final String entityType; // Type of entity (schedule, reminder, etc.)
  final ConflictResolutionType resolutionType;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final Map<String, dynamic>? resolvedData; // Result after resolution
  final String? reason; // User-provided reason for manual resolution
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final bool isResolved;

  const ConflictResolution({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.resolutionType,
    required this.localData,
    required this.remoteData,
    required this.createdAt,
    this.resolvedData,
    this.reason,
    this.resolvedAt,
    this.isResolved = false,
  });

  /// Create a new conflict resolution
  factory ConflictResolution.create({
    required String id,
    required String entityId,
    required String entityType,
    required ConflictResolutionType resolutionType,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    String? reason,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError('Conflict resolution ID cannot be empty');
    }
    if (entityId.trim().isEmpty) {
      throw ArgumentError('Entity ID cannot be empty');
    }
    if (entityType.trim().isEmpty) {
      throw ArgumentError('Entity type cannot be empty');
    }

    return ConflictResolution(
      id: id,
      entityId: entityId,
      entityType: entityType,
      resolutionType: resolutionType,
      localData: localData,
      remoteData: remoteData,
      reason: reason,
      createdAt: DateTime.now(),
    );
  }

  /// Create a copy with updated fields
  ConflictResolution copyWith({
    String? id,
    String? entityId,
    String? entityType,
    ConflictResolutionType? resolutionType,
    Map<String, dynamic>? localData,
    Map<String, dynamic>? remoteData,
    Map<String, dynamic>? resolvedData,
    String? reason,
    DateTime? createdAt,
    DateTime? resolvedAt,
    bool? isResolved,
  }) {
    return ConflictResolution(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      resolutionType: resolutionType ?? this.resolutionType,
      localData: localData ?? this.localData,
      remoteData: remoteData ?? this.remoteData,
      resolvedData: resolvedData ?? this.resolvedData,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      isResolved: isResolved ?? this.isResolved,
    );
  }

  /// Mark as resolved with the given data
  ConflictResolution resolve(Map<String, dynamic> resolvedData) {
    return copyWith(resolvedData: resolvedData, resolvedAt: DateTime.now(), isResolved: true);
  }

  /// Get the data to use based on resolution type
  Map<String, dynamic> getResolvedData() {
    if (resolvedData != null) {
      return resolvedData!;
    }

    switch (resolutionType) {
      case ConflictResolutionType.useLocal:
        return localData;
      case ConflictResolutionType.useRemote:
        return remoteData;
      case ConflictResolutionType.merge:
        // Simple merge strategy - remote overwrites local
        return {...localData, ...remoteData};
      case ConflictResolutionType.manual:
        throw StateError('Manual resolution requires resolved data to be set');
    }
  }

  /// Check if this conflict requires manual intervention
  bool get requiresManualResolution => resolutionType == ConflictResolutionType.manual && !isResolved;

  /// Check if resolution is consistent (follows the specified strategy)
  bool get isConsistent {
    if (!isResolved || resolvedData == null) return false;

    final expectedData = getResolvedData();
    return _mapsEqual(resolvedData!, expectedData);
  }

  /// Helper method to compare maps for equality
  bool _mapsEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  @override
  List<Object?> get props => [
    id,
    entityId,
    entityType,
    resolutionType,
    localData,
    remoteData,
    resolvedData,
    reason,
    createdAt,
    resolvedAt,
    isResolved,
  ];

  @override
  String toString() {
    return 'ConflictResolution(id: $id, entityId: $entityId, entityType: $entityType, resolutionType: $resolutionType, isResolved: $isResolved)';
  }
}
