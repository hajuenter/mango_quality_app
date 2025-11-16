import 'package:cloud_firestore/cloud_firestore.dart';

class SeasonCrudModel {
  final String id;
  final String name;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;

  SeasonCrudModel({
    required this.id,
    required this.name,
    required this.status,
    this.startedAt,
    this.endedAt,
  });

  factory SeasonCrudModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SeasonCrudModel(
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      status: data["status"] ?? "none",
      startedAt: data["started_at"] != null
          ? (data["started_at"] as Timestamp).toDate()
          : null,
      endedAt: data["ended_at"] != null
          ? (data["ended_at"] as Timestamp).toDate()
          : null,
    );
  }
}
