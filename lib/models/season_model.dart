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

    // ------- PARSE started_at -------
    final startedRaw = data['started_at'];
    DateTime parsedStartedAt;

    if (startedRaw is Timestamp) {
      parsedStartedAt = startedRaw.toDate();
    } else if (startedRaw is String) {
      parsedStartedAt = DateTime.tryParse(startedRaw) ?? DateTime.now();
    } else {
      parsedStartedAt = DateTime.now();
    }

    // ------- PARSE ended_at -------
    final endedRaw = data['ended_at'];
    DateTime? parsedEndedAt;

    if (endedRaw is Timestamp) {
      parsedEndedAt = endedRaw.toDate();
    } else if (endedRaw is String) {
      parsedEndedAt = DateTime.tryParse(endedRaw);
    } else {
      parsedEndedAt = null;
    }

    return SeasonModel(
      id: doc.id,
      name: data['name'],
      startedAt: parsedStartedAt,
      endedAt: parsedEndedAt,
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
