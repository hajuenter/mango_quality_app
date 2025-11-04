import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/healthy_rotten_count_service.dart';
import '../models/healthy_rotten_count_model.dart';
import 'package:flutter/material.dart';

class HealthyRottenCountController extends GetxController {
  var healthyList = <HealthyRottenCountModel>[].obs;
  var rottenList = <HealthyRottenCountModel>[].obs;
  var isLoading = false.obs;

  HealthyRottenCountService? _service;
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

      _service = HealthyRottenCountService(token: token);
      _isInitialized = true;

      await fetchDetections();

      _startPolling();
    } catch (e) {
      _isInitialized = false;
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isInitialized && _service != null && _isPageActive) {
        _fetchDetectionsSilent();
      } else {
        debugPrint('⏸️ Polling skipped - page not active');
      }
    });
  }

  Future<void> fetchDetections() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;

      final healthyResponse = await _service!.getHealthy();
      final rottenResponse = await _service!.getRotten();

      healthyList.value = healthyResponse.detections;
      rottenList.value = rottenResponse.detections;
    } catch (e) {
      debugPrint('Error fetching detections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDetectionsWithDelay() async {
    if (_service == null || !_isPageActive) return;

    try {
      isLoading.value = true;

      final startTime = DateTime.now();

      final healthyResponse = await _service!.getHealthy();
      final rottenResponse = await _service!.getRotten();

      healthyList.value = healthyResponse.detections;
      rottenList.value = rottenResponse.detections;

      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(seconds: 3) - elapsed;

      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error fetching detections: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDetectionsSilent() async {
    if (_service == null || !_isPageActive) return;

    try {
      final healthyResponse = await _service!.getHealthy();
      final rottenResponse = await _service!.getRotten();

      final newHealthyList = healthyResponse.detections;
      final newRottenList = rottenResponse.detections;

      if (newHealthyList.length != healthyList.length ||
          newRottenList.length != rottenList.length) {
        healthyList.assignAll(newHealthyList);
        rottenList.assignAll(newRottenList);
      }
    } catch (e) {
      debugPrint('Error in silent fetch: $e');
    }
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
