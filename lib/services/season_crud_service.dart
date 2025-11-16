import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/season_crud_model.dart';

class SeasonCrudService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<SeasonCrudModel?> getActiveSeason() async {
    final doc = await _db.collection("season").doc("active").get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    if (data["status"] != "active") return null;

    return SeasonCrudModel.fromDoc(doc);
  }

  Future<bool> isNameExist(String name) async {
    final query = await _db
        .collection("season")
        .where("name", isEqualTo: name)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<String?> startSeason(String name) async {
    // Cek musim aktif
    final active = await getActiveSeason();
    if (active != null) {
      return "Masih ada musim aktif. Hentikan dulu sebelum membuat yang baru.";
    }

    // Cek nama duplikat
    if (await isNameExist(name)) {
      return "Nama musim '$name' sudah pernah digunakan.";
    }

    final now = DateTime.now();
    final id = "${now.toIso8601String()}_${name.replaceAll(' ', '_')}";

    final seasonData = {
      "id": id,
      "name": name,
      "status": "active",
      "started_at": now,
      "ended_at": null,
    };

    // Simpan riwayat
    await _db.collection("season").doc(id).set(seasonData);

    // Simpan global active
    await _db.collection("season").doc("active").set({
      "id": id,
      "name": name,
      "status": "active",
      "started_at": now,
      "ended_at": null,
    });

    return null; // null berarti berhasil
  }

  Future<String?> stopSeason() async {
    final active = await getActiveSeason();
    if (active == null) return "Tidak ada musim aktif.";

    final now = DateTime.now();

    // Update musim riwayat
    await _db.collection("season").doc(active.id).update({
      "status": "inactive",
      "ended_at": now,
    });

    // Kosongkan dokumen active
    await _db.collection("season").doc("active").set({
      "id": null,
      "name": null,
      "status": "none",
      "started_at": null,
      "ended_at": null,
    });

    return null;
  }
}
