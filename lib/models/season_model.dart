import 'package:cloud_firestore/cloud_firestore.dart';

class SeasonModel {
  final String id;
  final String name;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final int healthyCount;
  final int rottenCount;
  final int totalCount;

  SeasonModel({
    required this.id,
    required this.name,
    required this.startedAt,
    this.endedAt,
    required this.status,
    this.healthyCount = 0,
    this.rottenCount = 0,
    this.totalCount = 0,
  });

  bool get isActive => status == 'active';

  factory SeasonModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SeasonModel(
      id: data['id'],
      name: data['name'],
      startedAt: (data['started_at'] as Timestamp).toDate(),
      endedAt: data['ended_at'] != null
          ? (data['ended_at'] as Timestamp).toDate()
          : null,
      status: data['status'],
      healthyCount: data['healthy_count'] ?? 0,
      rottenCount: data['rotten_count'] ?? 0,
      totalCount: data['total_count'] ?? 0,
    );
  }

  SeasonModel copyWith({
    String? id,
    String? name,
    DateTime? startedAt,
    DateTime? endedAt,
    String? status,
    int? healthyCount,
    int? rottenCount,
    int? totalCount,
  }) {
    return SeasonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      healthyCount: healthyCount ?? this.healthyCount,
      rottenCount: rottenCount ?? this.rottenCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
