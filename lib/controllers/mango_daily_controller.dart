import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/mango_statistic_model.dart';
import '../services/mango_statistic_service.dart';

class MangoDailyController extends GetxController {
  final MangoStatisticService _service = MangoStatisticService();

  var dailyData = <MangoStatisticModel>[].obs;
  var isLoading = true.obs;

  var selectedDate = DateTime.now().obs;
  var selectedFilter = 'Harian'.obs;

  DateTime? customStartDate;
  DateTime? customEndDate;

  StreamSubscription<List<MangoStatisticModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToRealtime();
  }

  void _listenToRealtime() {
    isLoading.value = true;

    _streamSubscription?.cancel();

    _streamSubscription = _service.streamStatistics().listen(
      (data) {
        _filterDataBySelectedPeriod(data);
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('❌ Firestore stream error: $e');
        isLoading.value = false;
      },
    );
  }

  void _filterDataBySelectedPeriod(List<MangoStatisticModel> allData) {
    final filter = selectedFilter.value;

    if (filter == 'Harian') {
      final selected = selectedDate.value;

      dailyData.assignAll(
        allData.where(
          (d) =>
              d.timestamp.year == selected.year &&
              d.timestamp.month == selected.month &&
              d.timestamp.day == selected.day,
        ),
      );
    } else if (filter == 'Custom' &&
        customStartDate != null &&
        customEndDate != null) {
      dailyData.assignAll(
        allData.where((d) {
          final date = DateTime(
            d.timestamp.year,
            d.timestamp.month,
            d.timestamp.day,
          );
          final start = DateTime(
            customStartDate!.year,
            customStartDate!.month,
            customStartDate!.day,
          );
          final end = DateTime(
            customEndDate!.year,
            customEndDate!.month,
            customEndDate!.day,
          );

          return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
              (date.isBefore(end) || date.isAtSameMomentAs(end));
        }),
      );
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    _listenToRealtime();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate = start;
    customEndDate = end;
    selectedFilter.value = 'Custom';
    _listenToRealtime();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    selectedFilter.value = 'Harian';
    _listenToRealtime();
  }

  Future<void> refreshWithDelay() async {
    try {
      isLoading.value = true;
      final start = DateTime.now();

      final data = await _service.fetchStatisticsOnce();
      _filterDataBySelectedPeriod(data);

      final elapsed = DateTime.now().difference(start);
      final remaining = const Duration(seconds: 2) - elapsed;

      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error refreshing daily data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int get healthyCount => dailyData.where((d) => d.isHealthy).length;
  int get rottenCount => dailyData.where((d) => d.isRotten).length;
  int get totalCount => dailyData.length;

  double get healthyPercentage =>
      totalCount == 0 ? 0.0 : (healthyCount / totalCount) * 100;

  double get rottenPercentage =>
      totalCount == 0 ? 0.0 : (rottenCount / totalCount) * 100;

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
