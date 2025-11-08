import 'package:cloud_firestore/cloud_firestore.dart';

class HealthyRottenCountModel {
  final String id;
  final String label;
  final String imageUrl;
  final double confidence;
  final DateTime timestamp;

  HealthyRottenCountModel({
    required this.id,
    required this.label,
    required this.imageUrl,
    required this.confidence,
    required this.timestamp,
  });

  factory HealthyRottenCountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return HealthyRottenCountModel(
      id: doc.id,
      label: data['label'] ?? '',
      imageUrl: data['image_url'] ?? '',
      confidence: (data['confidence'] is num)
          ? (data['confidence'] as num).toDouble()
          : 0.0,
      timestamp: _parseTimestamp(data['timestamp']),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }
}
