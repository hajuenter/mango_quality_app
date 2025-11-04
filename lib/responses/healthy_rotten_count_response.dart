import '../models/healthy_rotten_count_model.dart';

class HealthyRottenCountResponse {
  final bool success;
  final int count;
  final List<HealthyRottenCountModel> detections;

  HealthyRottenCountResponse({
    required this.success,
    required this.count,
    required this.detections,
  });

  factory HealthyRottenCountResponse.fromJson(Map<String, dynamic> json) {
    return HealthyRottenCountResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      detections:
          (json['detections'] as List<dynamic>?)
              ?.map(
                (e) =>
                    HealthyRottenCountModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'detections': detections
          .map(
            (e) => {
              'id': e.id,
              'label': e.label,
              'image_url': e.imageUrl,
              'confidence': e.confidence,
              'timestamp': e.timestamp.toIso8601String(),
            },
          )
          .toList(),
    };
  }
}
