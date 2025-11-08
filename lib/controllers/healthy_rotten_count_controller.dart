import 'dart:async';
import 'package:get/get.dart';
import '../services/healthy_rotten_count_service.dart';
import '../models/healthy_rotten_count_model.dart';

class HealthyRottenCountController extends GetxController {
  var healthyList = <HealthyRottenCountModel>[].obs;
  var rottenList = <HealthyRottenCountModel>[].obs;
  var healthyCount = 0.obs;
  var rottenCount = 0.obs;
  var totalCount = 0.obs;
  var isLoading = true.obs;

  final HealthyRottenCountService _service = HealthyRottenCountService();
  StreamSubscription? _streamSubscription;

  bool _isRefreshing = false;

  @override
  void onInit() {
    super.onInit();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    final initialData = await _service.fetchHealthyRottenCountsOnce();
    _applyData(initialData);

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    isLoading.value = false;

    _listenToFirestore();
  }

  void _listenToFirestore() {
    bool isFirstSnapshot = true;

    _streamSubscription = _service.streamHealthyRottenCounts().listen((data) {
      if (isFirstSnapshot) {
        isFirstSnapshot = false;
        return;
      }

      if (_isRefreshing) return;
      _applyData(data);
    });
  }

  void _applyData(Map<String, dynamic> data) {
    healthyCount.value = data['healthyCount'];
    rottenCount.value = data['rottenCount'];
    totalCount.value = data['totalCount'];
    healthyList.value = data['healthyList'];
    rottenList.value = data['rottenList'];
  }

  Future<void> refreshWithDelay() async {
    _isRefreshing = true; // <-- Matikan update dari stream
    isLoading.value = true; // tampilkan skeleton

    await Future.delayed(const Duration(seconds: 3));

    final freshData = await _service.fetchHealthyRottenCountsOnce();
    _applyData(freshData);

    isLoading.value = false;
    _isRefreshing = false; // <-- Hidupkan stream lagi
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
