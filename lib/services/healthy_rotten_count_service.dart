import 'package:dio/dio.dart';
import '../config/api.dart';

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

  Future<Map<String, dynamic>> getHealthy() async {
    final response = await _dio.get(ApiConfig.healthyDetection);
    return response.data;
  }

  Future<Map<String, dynamic>> getRotten() async {
    final response = await _dio.get(ApiConfig.rottenDetection);
    return response.data;
  }
}
