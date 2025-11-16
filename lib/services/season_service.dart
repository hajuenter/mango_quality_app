import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/season_model.dart';

class SeasonService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<SeasonModel>> streamAllSeasons() {
    return _db
        .collection('season')
        .where(FieldPath.documentId, isNotEqualTo: 'active')
        .orderBy(FieldPath.documentId)
        .snapshots()
        .asyncMap((snapshot) async {
          List<SeasonModel> seasons = [];

          for (var doc in snapshot.docs) {
            final season = SeasonModel.fromDoc(doc);

            final counts = await _getSeasonCounts(season.name);

            seasons.add(
              season.copyWith(
                healthyCount: counts['healthy'] ?? 0,
                rottenCount: counts['rotten'] ?? 0,
                totalCount: counts['total'] ?? 0,
              ),
            );
          }

          return seasons;
        });
  }

  // Method baru untuk fetch sekali (non-stream)
  Future<List<SeasonModel>> fetchSeasonsOnce() async {
    try {
      final snapshot = await _db
          .collection('season')
          .where(FieldPath.documentId, isNotEqualTo: 'active')
          .orderBy(FieldPath.documentId)
          .get();

      List<SeasonModel> seasons = [];

      for (var doc in snapshot.docs) {
        final season = SeasonModel.fromDoc(doc);

        final counts = await _getSeasonCounts(season.name);

        seasons.add(
          season.copyWith(
            healthyCount: counts['healthy'] ?? 0,
            rottenCount: counts['rotten'] ?? 0,
            totalCount: counts['total'] ?? 0,
          ),
        );
      }

      return seasons;
    } catch (e) {
      debugPrint('Error fetching seasons once: $e');
      return [];
    }
  }

  Future<Map<String, int>> _getSeasonCounts(String seasonName) async {
    try {
      final snapshot = await _db
          .collection('mango_detections')
          .where('season_name', isEqualTo: seasonName)
          .get();

      int healthy = 0;
      int rotten = 0;

      for (var doc in snapshot.docs) {
        final raw = (doc['label'] ?? "").toString().toLowerCase();

        if (raw.contains('healthy')) {
          healthy++;
        } else if (raw.contains('rotten')) {
          rotten++;
        }
      }

      return {'healthy': healthy, 'rotten': rotten, 'total': healthy + rotten};
    } catch (e) {
      debugPrint('Error getting season counts: $e');
      return {'healthy': 0, 'rotten': 0, 'total': 0};
    }
  }

  Future<SeasonModel?> getSeason(String id) async {
    final doc = await _db.collection('season').doc(id).get();
    if (!doc.exists) return null;

    final season = SeasonModel.fromDoc(doc);
    final counts = await _getSeasonCounts(season.name);

    return season.copyWith(
      healthyCount: counts['healthy'] ?? 0,
      rottenCount: counts['rotten'] ?? 0,
      totalCount: counts['total'] ?? 0,
    );
  }

  Stream<List<Map<String, dynamic>>> streamSeasonDetections(String seasonName) {
    return _db
        .collection('mango_detections')
        .where('season_name', isEqualTo: seasonName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.data()).toList());
  }
}
