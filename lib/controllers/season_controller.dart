import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/season_model.dart';
import '../services/season_service.dart';

class SeasonController extends GetxController {
  final SeasonService _service = SeasonService();

  var seasonList = <SeasonModel>[].obs;
  var isLoading = true.obs;

  StreamSubscription<List<SeasonModel>>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenSeasons();
  }

  void _listenSeasons() {
    isLoading.value = true;

    _streamSubscription?.cancel();

    _streamSubscription = _service.streamAllSeasons().listen(
      (seasons) {
        seasons.sort((a, b) => b.startedAt.compareTo(a.startedAt));
        seasonList.assignAll(seasons);
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('❌ Season stream error: $e');
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshWithDelay() async {
    try {
      isLoading.value = true;
      final start = DateTime.now();

      final seasons = await _service.fetchSeasonsOnce();
      seasons.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      seasonList.assignAll(seasons);

      final elapsed = DateTime.now().difference(start);
      final remaining = const Duration(seconds: 2) - elapsed;

      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } catch (e) {
      debugPrint('Error refreshing season data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
