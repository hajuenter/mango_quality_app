import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/mango_latest_service.dart';
import '../models/mango_latest_model.dart';
import 'package:flutter/material.dart';

class MangoLatestController extends GetxController {
  var latestDetections = <MangoLatestModel>[].obs;
  var isLoading = false.obs;

  MangoLatestService? _service;
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
      if (user == null) {
        return;
      }

      final token = await user.getIdToken();

      _service = MangoLatestService(token: token);
      _isInitialized = true;

      await fetchLatestDetections();

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
        _fetchLatestDetectionsSilent();
      } else {
        debugPrint('⏸️ Latest polling skipped - page not active');
      }
    });
  }

  Future<void> fetchLatestDetections() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;

      final response = await _service!.getLatestDetections();
      latestDetections.value = response.detections;
    } catch (e) {
      debugPrint('Error fetching latest detections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLatestDetectionsWithDelay() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;

      final startTime = DateTime.now();

      final response = await _service!.getLatestDetections();
      latestDetections.value = response.detections;

      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(seconds: 3) - elapsed;

      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error fetching latest detections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchLatestDetectionsSilent() async {
    if (_service == null || !_isPageActive) return;

    try {
      final response = await _service!.getLatestDetections();
      final newDetections = response.detections;

      if (newDetections.length != latestDetections.length ||
          _hasChanges(newDetections)) {
        latestDetections.assignAll(newDetections);
      }
    } catch (e) {
      debugPrint('Error in silent fetch latest: $e');
    }
  }

  bool _hasChanges(List<MangoLatestModel> newDetections) {
    if (newDetections.length != latestDetections.length) return true;

    for (int i = 0; i < newDetections.length; i++) {
      if (newDetections[i].id != latestDetections[i].id) {
        return true;
      }
    }
    return false;
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
