class ApiConfig {
  static const String baseUrl = 'http://192.168.1.7:5000/api';

  static const String healthyDetection = '$baseUrl/detections/healthy';
  static const String rottenDetection = '$baseUrl/detections/rotten';
  static const String latestDetection = '$baseUrl/detections/latest';
  static const String allDetection = '$baseUrl/detections';
}
