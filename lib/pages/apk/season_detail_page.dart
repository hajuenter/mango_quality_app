import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/colors.dart';
import '../../models/season_model.dart';
import '../../services/season_service.dart';

class SeasonDetailPage extends StatelessWidget {
  final SeasonService _service = SeasonService();

  SeasonDetailPage({super.key});

  void _goBack() {
    Get.back();
  }

  String _formatLabel(String? raw) {
    if (raw == null) return "-";

    switch (raw) {
      case 'mango_healthy':
        return 'Mangga Sehat';
      case 'mango_rotten':
        return 'Mangga Busuk';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final SeasonModel season = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 77, // tinggi fix supaya sama dengan header lainnya
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primaryAuth,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Tombol back di kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _goBack,
                    ),
                  ),

                  Center(
                    child: Text(
                      season.name,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder(
                stream: _service.streamSeasonDetections(season.name),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final detections = snapshot.data!;

                  if (detections.isEmpty) {
                    return Center(
                      child: Text(
                        "Tidak ada data sortir pada musim ini.",
                        style: GoogleFonts.rubik(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: detections.length,
                    itemBuilder: (context, index) {
                      final item = detections[index];

                      return Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // ================= IMAGE =================
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image_url'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatLabel(item['label']),
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      DateFormat(
                                        'd MMMM yyyy, HH:mm',
                                        'id_ID',
                                      ).format(item['timestamp'].toDate()),
                                      style: GoogleFonts.rubik(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
