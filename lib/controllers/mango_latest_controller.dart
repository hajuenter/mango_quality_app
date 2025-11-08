import 'dart:async';
import 'package:get/get.dart';
import '../services/mango_latest_service.dart';
import '../models/mango_latest_model.dart';

class MangoLatestController extends GetxController {
  var latestDetections = <MangoLatestModel>[].obs;
  var isLoading = true.obs;
  var _isRefreshing = false;

  final MangoLatestService _service = MangoLatestService();
  StreamSubscription<List<MangoLatestModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    final initialData = await _service.fetchLatestOnce();
    latestDetections.assignAll(initialData);

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    isLoading.value = false;

    _listenToRealtimeDetections();
  }

  void _listenToRealtimeDetections() {
    bool isFirstSnapshot = true;

    _streamSubscription = _service.streamLatestDetections().listen((data) {
      if (isFirstSnapshot) {
        isFirstSnapshot = false;
        return;
      }

      if (_isRefreshing) return;
      latestDetections.assignAll(data);
    });
  }

  Future<void> refreshWithDelay() async {
    _isRefreshing = true;
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 3));

    final freshData = await _service.fetchLatestOnce();
    latestDetections.assignAll(freshData);

    isLoading.value = false;
    _isRefreshing = false;
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
