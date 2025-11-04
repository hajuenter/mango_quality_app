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
  });

  factory MangoLatestModel.fromJson(Map<String, dynamic> json) {
    return MangoLatestModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      method: json['method'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      date: json['date'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'confidence': confidence,
      'image_url': imageUrl,
      'method': method,
      'timestamp': timestamp.toIso8601String(),
      'date': date,
      'month': month,
      'year': year,
    };
  }

  String get formattedTime {
    return '${date.split('-')[2]}/${date.split('-')[1]}/${date.split('-')[0]} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  String get type {
    return label.contains('healthy') ? 'sehat' : 'busuk';
  }

  String get message {
    return label.contains('healthy')
        ? 'Mangga Sehat Terdeteksi'
        : 'Mangga Busuk Terdeteksi';
  }
}
