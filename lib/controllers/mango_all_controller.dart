import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/mango_all_service.dart';
import '../models/mango_all_model.dart';
import 'package:flutter/material.dart';

class MangoAllController extends GetxController {
  var allDetections = <MangoAllModel>[].obs;
  var isLoading = false.obs;

  MangoAllService? _service;
  Timer? _pollingTimer;
  bool _isInitialized = false;
  bool _isPageActive = true;

  @override
  void onInit() {
    super.onInit();
    _initServiceAndLoadData();
  }

  @override
  void onClose() {
    _isPageActive = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    super.onClose();
  }

  Future<void> _initServiceAndLoadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final token = await user.getIdToken();
      _service = MangoAllService(token: token);
      _isInitialized = true;

      await fetchAllDetections();
      _startPolling();
    } catch (e) {
      _isInitialized = false;
      debugPrint('Error initializing service: $e');
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isInitialized && _service != null && _isPageActive) {
        _fetchAllDetectionsSilent();
      } else {
        debugPrint('⏸️ All detections polling skipped - page not active');
      }
    });
  }

  Future<void> fetchAllDetections() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;
      final response = await _service!.getAllDetections();

      response.detections.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      allDetections.value = response.detections;
    } catch (e) {
      debugPrint('Error fetching all detections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllDetectionsWithDelay() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;
      final startTime = DateTime.now();

      final response = await _service!.getAllDetections();
      response.detections.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      allDetections.value = response.detections;

      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(seconds: 3) - elapsed;
      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error fetching all detections with delay: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAllDetectionsSilent() async {
    if (_service == null || !_isPageActive) return;

    try {
      final response = await _service!.getAllDetections();
      response.detections.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final newDetections = response.detections;
      if (newDetections.length != allDetections.length ||
          _hasChanges(newDetections)) {
        allDetections.assignAll(newDetections);
      }
    } catch (e) {
      debugPrint('Error in silent fetch all: $e');
    }
  }

  bool _hasChanges(List<MangoAllModel> newDetections) {
    if (newDetections.length != allDetections.length) return true;
    for (int i = 0; i < newDetections.length; i++) {
      if (newDetections[i].id != allDetections[i].id) {
        return true;
      }
    }
    return false;
  }

  List<MangoAllModel> filterByDate(DateTime? selectedDate) {
    if (selectedDate == null) return allDetections;
    return allDetections.where((detection) {
      final detectionDate = DateTime.parse(detection.date);
      return detectionDate.year == selectedDate.year &&
          detectionDate.month == selectedDate.month &&
          detectionDate.day == selectedDate.day;
    }).toList();
  }

  List<MangoAllModel> filterByType(
    List<MangoAllModel> detections,
    String selectedFilter,
  ) {
    if (selectedFilter == 'Semua') return detections;
    return detections
        .where(
          (detection) =>
              detection.type.toLowerCase() == selectedFilter.toLowerCase(),
        )
        .toList();
  }

  void pausePolling() {
    _isPageActive = false;
    _pollingTimer?.cancel();
  }

  void resumePolling() {
    _isPageActive = true;
    if (_isInitialized) {
      _startPolling();
    }
  }
}
