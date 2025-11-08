import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mango_latest_model.dart';

class MangoLatestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MangoLatestModel>> streamLatestDetections() {
    return _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return MangoLatestModel.fromJson({'id': doc.id, ...data});
          }).toList();
        });
  }

  Future<List<MangoLatestModel>> fetchLatestOnce() async {
    final snapshot = await _firestore
        .collection('mango_detections')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return MangoLatestModel.fromJson({'id': doc.id, ...data});
    }).toList();
  }
}
