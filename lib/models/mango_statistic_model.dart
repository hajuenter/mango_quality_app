import 'package:cloud_firestore/cloud_firestore.dart';

class MangoStatisticModel {
  final String id;
  final String label;
  final double confidence;
  final String imageUrl;
  final String method;
  final DateTime timestamp;
  final String date;
  final String month;
  final String year;

  MangoStatisticModel({
    required this.id,
    required this.label,
    required this.confidence,
    required this.imageUrl,
    required this.method,
    required this.timestamp,
    required this.date,
    required this.month,
    required this.year,
  });

  factory MangoStatisticModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final timestampField = data['timestamp'];
    DateTime parsedTimestamp;
    if (timestampField is Timestamp) {
      parsedTimestamp = timestampField.toDate();
    } else if (timestampField is String) {
      parsedTimestamp = DateTime.tryParse(timestampField) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    return MangoStatisticModel(
      id: doc.id,
      label: data['label'] ?? '',
      confidence: (data['confidence'] ?? 0.0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      method: data['method'] ?? '',
      timestamp: parsedTimestamp,
      date: data['date'] ?? '',
      month: data['month'] ?? '',
      year: data['year'] ?? '',
    );
  }

  bool get isHealthy => label.contains('healthy');
  bool get isRotten => label.contains('rotten');
}
