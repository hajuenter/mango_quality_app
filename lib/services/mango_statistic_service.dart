import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mango_statistic_model.dart';

class MangoStatisticService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream realtime dari Firestore (urut berdasarkan waktu terbaru)
  Stream<List<MangoStatisticModel>> streamStatistics() {
    return _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MangoStatisticModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Fetch manual (untuk refresh delay 3 detik)
  Future<List<MangoStatisticModel>> fetchStatisticsOnce() async {
    final snapshot = await _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MangoStatisticModel.fromFirestore(doc))
        .toList();
  }
}
