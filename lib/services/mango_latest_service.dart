import 'package:dio/dio.dart';

import '../config/api.dart';
import '../responses/mango_latest_response.dart';

class MangoLatestService {
  final Dio _dio;

  MangoLatestService({String? token})
    : _dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<MangoLatestResponse> getLatestDetections() async {
    final response = await _dio.get(ApiConfig.latestDetection);
    return MangoLatestResponse.fromJson(response.data);
  }
}
