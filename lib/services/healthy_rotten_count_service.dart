import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/healthy_rotten_count_model.dart';

class HealthyRottenCountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> streamHealthyRottenCounts() {
    return _firestore.collection('mango_detections').snapshots().map((
      snapshot,
    ) {
      int healthyCount = 0;
      int rottenCount = 0;
      List<HealthyRottenCountModel> healthyList = [];
      List<HealthyRottenCountModel> rottenList = [];

      for (var doc in snapshot.docs) {
        final model = HealthyRottenCountModel.fromFirestore(doc);

        if (model.label == 'mango_healthy') {
          healthyCount++;
          healthyList.add(model);
        } else if (model.label == 'mango_rotten') {
          rottenCount++;
          rottenList.add(model);
        }
      }

      return {
        'healthyCount': healthyCount,
        'rottenCount': rottenCount,
        'healthyList': healthyList,
        'rottenList': rottenList,
        'totalCount': healthyCount + rottenCount,
      };
    });
  }
}
