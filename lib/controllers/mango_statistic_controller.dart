import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/mango_statistic_model.dart';
import '../services/mango_statistic_service.dart';

class MangoStatisticController extends GetxController {
  final MangoStatisticService _service = MangoStatisticService();

  var allData = <MangoStatisticModel>[].obs;
  var filteredData = <MangoStatisticModel>[].obs;

  var isLoading = true.obs;
  DateTime? selectedDate;

  StreamSubscription<List<MangoStatisticModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToRealtime();
  }

  void _listenToRealtime() {
    isLoading.value = true;
    _streamSubscription = _service.streamStatistics().listen(
      (data) {
        allData.assignAll(data);
        _applyFilter();
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('❌ Firestore stream error: $e');
        isLoading.value = false;
      },
    );
  }

  void filterByDate(DateTime? date) {
    selectedDate = date;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedDate == null) {
      filteredData.assignAll(allData);
    } else {
      filteredData.assignAll(
        allData.where(
          (d) =>
              d.timestamp.year == selectedDate!.year &&
              d.timestamp.month == selectedDate!.month &&
              d.timestamp.day == selectedDate!.day,
        ),
      );
    }
  }

  Future<void> refreshWithDelay() async {
    try {
      isLoading.value = true;
      final start = DateTime.now();

      final data = await _service.fetchStatisticsOnce();
      allData.assignAll(data);
      selectedDate = null;
      _applyFilter();

      final elapsed = DateTime.now().difference(start);
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

  int get healthyCount => filteredData.where((d) => d.isHealthy).length;

  int get rottenCount => filteredData.where((d) => d.isRotten).length;

  Map<int, int> get healthyPerMonth {
    final map = <int, int>{};
    for (var d in filteredData) {
      final month = d.timestamp.month;
      if (d.isHealthy) map[month] = (map[month] ?? 0) + 1;
    }
    return map;
  }

  Map<int, int> get rottenPerMonth {
    final map = <int, int>{};
    for (var d in filteredData) {
      final month = d.timestamp.month;
      if (d.isRotten) map[month] = (map[month] ?? 0) + 1;
    }
    return map;
  }

  Map<int, int> get healthyPerYear {
    final map = <int, int>{};
    final source = selectedDate == null ? allData : filteredData;
    for (var d in source) {
      final year = d.timestamp.year;
      if (d.isHealthy) map[year] = (map[year] ?? 0) + 1;
    }
    return map;
  }

  Map<int, int> get rottenPerYear {
    final map = <int, int>{};
    final source = selectedDate == null ? allData : filteredData;
    for (var d in source) {
      final year = d.timestamp.year;
      if (d.isRotten) map[year] = (map[year] ?? 0) + 1;
    }
    return map;
  }

  bool get hasMonthlyData =>
      healthyPerMonth.isNotEmpty || rottenPerMonth.isNotEmpty;
  bool get hasYearlyData =>
      healthyPerYear.isNotEmpty || rottenPerYear.isNotEmpty;

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
