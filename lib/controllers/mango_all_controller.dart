import 'dart:async';
import 'package:get/get.dart';
import '../services/mango_all_service.dart';
import '../models/mango_all_model.dart';
import 'package:flutter/material.dart';

class MangoAllController extends GetxController {
  var allDetections = <MangoAllModel>[].obs;
  var isLoading = true.obs;

  final MangoAllService _service = MangoAllService();
  StreamSubscription<List<MangoAllModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToRealtime();
  }

  void _listenToRealtime() {
    isLoading.value = true;
    _streamSubscription = _service.streamAllDetections().listen(
      (detections) {
        allDetections.assignAll(detections);
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('❌ Firestore stream error: $e');
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshWithDelay() async {
    try {
      isLoading.value = true;
      final startTime = DateTime.now();

      final data = await _service.fetchAllDetectionsOnce();
      allDetections.assignAll(data);

      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(seconds: 3) - elapsed;
      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error refreshing with delay: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<MangoAllModel> filterByDate(DateTime? selectedDate) {
    if (selectedDate == null) return allDetections;
    return allDetections.where((detection) {
      return detection.timestamp.year == selectedDate.year &&
          detection.timestamp.month == selectedDate.month &&
          detection.timestamp.day == selectedDate.day;
    }).toList();
  }

  List<MangoAllModel> filterByType(
    List<MangoAllModel> detections,
    String selectedFilter,
  ) {
    if (selectedFilter == 'Semua') return detections;
    return detections
        .where((d) => d.type.toLowerCase() == selectedFilter.toLowerCase())
        .toList();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
