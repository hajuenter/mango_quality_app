import 'dart:async';
import 'package:get/get.dart';
import '../services/mango_latest_service.dart';
import '../models/mango_latest_model.dart';
import 'package:flutter/material.dart';

class MangoLatestController extends GetxController {
  var latestDetections = <MangoLatestModel>[].obs;
  var isLoading = true.obs; // default true agar skeleton muncul pertama kali

  final MangoLatestService _service = MangoLatestService();
  StreamSubscription<List<MangoLatestModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToRealtimeDetections();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  void _listenToRealtimeDetections() {
    _streamSubscription = _service.streamLatestDetections().listen(
      (data) {
        latestDetections.assignAll(data);
        isLoading.value = false;
      },
      onError: (error) {
        debugPrint('❌ Firestore stream error: $error');
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshWithDelay() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }
}
