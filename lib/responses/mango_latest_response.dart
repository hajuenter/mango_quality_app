import '../models/mango_latest_model.dart';

class MangoLatestResponse {
  final bool success;
  final int count;
  final List<MangoLatestModel> detections;

  MangoLatestResponse({
    required this.success,
    required this.count,
    required this.detections,
  });

  factory MangoLatestResponse.fromJson(Map<String, dynamic> json) {
    return MangoLatestResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      detections:
          (json['detections'] as List<dynamic>?)
              ?.map(
                (item) =>
                    MangoLatestModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'detections': detections.map((item) => item.toJson()).toList(),
    };
  }
}
