import 'package:dio/dio.dart';

import '../config/api.dart';
import '../responses/mango_all_response.dart';

class MangoAllService {
  final Dio _dio;

  MangoAllService({String? token})
    : _dio = Dio(
        BaseOptions(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<MangoAllResponse> getAllDetections() async {
    final response = await _dio.get(ApiConfig.allDetection);
    return MangoAllResponse.fromJson(response.data);
  }
}
