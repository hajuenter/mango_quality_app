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

  factory HealthyRottenCountModel.fromJson(Map<String, dynamic> json) {
    return HealthyRottenCountModel(
      id: json['id'],
      label: json['label'],
      imageUrl: json['image_url'],
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
