import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mango_all_model.dart';

class MangoAllService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream realtime untuk semua deteksi (urut waktu terbaru → terlama)
  Stream<List<MangoAllModel>> streamAllDetections() {
    return _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MangoAllModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Fetch manual (untuk refresh dengan delay 3 detik)
  Future<List<MangoAllModel>> fetchAllDetectionsOnce() async {
    final snapshot = await _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MangoAllModel.fromFirestore(doc))
        .toList();
  }
}
