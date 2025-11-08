import 'package:cloud_firestore/cloud_firestore.dart';

class MangoLatestModel {
  final String id;
  final String label;
  final double confidence;
  final String imageUrl;
  final String method;
  final DateTime timestamp;
  final String date;
  final String month;
  final String year;
  final String? seasonName;
  final String? seasonStatus;

  MangoLatestModel({
    required this.id,
    required this.label,
    required this.confidence,
    required this.imageUrl,
    required this.method,
    required this.timestamp,
    required this.date,
    required this.month,
    required this.year,
    this.seasonName,
    this.seasonStatus,
  });

  factory MangoLatestModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedTimestamp;

    if (json['timestamp'] is Timestamp) {
      parsedTimestamp = (json['timestamp'] as Timestamp).toDate();
    } else if (json['timestamp'] is String) {
      parsedTimestamp = DateTime.tryParse(json['timestamp']) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    return MangoLatestModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      method: json['method'] ?? '',
      timestamp: parsedTimestamp,
      date: json['date'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      seasonName: json['season_name'],
      seasonStatus: json['season_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'confidence': confidence,
      'image_url': imageUrl,
      'method': method,
      'timestamp': Timestamp.fromDate(timestamp),
      'date': date,
      'month': month,
      'year': year,
      'season_name': seasonName,
      'season_status': seasonStatus,
    };
  }

  String get formattedTime {
    return '${date.split('-')[2]}/${date.split('-')[1]}/${date.split('-')[0]} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  String get type => label.contains('healthy') ? 'sehat' : 'busuk';

  String get message => label.contains('healthy')
      ? 'Mangga Sehat Terdeteksi'
      : 'Mangga Busuk Terdeteksi';
}
