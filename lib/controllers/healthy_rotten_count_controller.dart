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
  var isLoading = true.obs; // awalnya true agar skeleton muncul di awal

  final HealthyRottenCountService _service = HealthyRottenCountService();
  StreamSubscription? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToFirestore();
  }

  void _listenToFirestore() {
    _streamSubscription = _service.streamHealthyRottenCounts().listen((data) {
      healthyCount.value = data['healthyCount'];
      rottenCount.value = data['rottenCount'];
      totalCount.value = data['totalCount'];
      healthyList.value = data['healthyList'];
      rottenList.value = data['rottenList'];
      isLoading.value = false;
    });
  }

  Future<void> refreshWithDelay() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    isLoading.value = false;
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
