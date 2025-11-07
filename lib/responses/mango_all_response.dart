import '../models/mango_all_model.dart';

class MangoAllResponse {
  final bool success;
  final int count;
  final List<MangoAllModel> detections;

  MangoAllResponse({
    required this.success,
    required this.count,
    required this.detections,
  });

  factory MangoAllResponse.fromJson(Map<String, dynamic> json) {
    return MangoAllResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      detections:
          (json['detections'] as List<dynamic>?)
              ?.map(
                (item) => MangoAllModel.fromJson(item as Map<String, dynamic>),
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
