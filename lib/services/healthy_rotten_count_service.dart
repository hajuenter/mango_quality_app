import 'package:dio/dio.dart';

import '../config/api.dart';
import '../responses/healthy_rotten_count_response.dart';

class HealthyRottenCountService {
  final Dio _dio;

  HealthyRottenCountService({String? token})
    : _dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<HealthyRottenCountResponse> getHealthy() async {
    final response = await _dio.get(ApiConfig.healthyDetection);
    return HealthyRottenCountResponse.fromJson(response.data);
  }

  Future<HealthyRottenCountResponse> getRotten() async {
    final response = await _dio.get(ApiConfig.rottenDetection);
    return HealthyRottenCountResponse.fromJson(response.data);
  }
}
