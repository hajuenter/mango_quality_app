import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/season_controller.dart';
import '../../config/colors.dart';

class SeasonListPage extends StatefulWidget {
  const SeasonListPage({super.key});

  @override
  State<SeasonListPage> createState() => _SeasonListPageState();
}

class _SeasonListPageState extends State<SeasonListPage> {
  late final SeasonController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SeasonController(), tag: "season_list");
  }

  @override
  void dispose() {
    Get.delete<SeasonController>(tag: "season_list", force: true);
    super.dispose();
  }

  void _goBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER CUSTOM ==================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primaryAuth,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _goBack,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Riwayat Musim',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.seasonList.isEmpty) {
                  return Center(
                    child: Text(
                      "Belum ada musim panen.",
                      style: GoogleFonts.rubik(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.seasonList.length,
                  itemBuilder: (context, index) {
                    final season = controller.seasonList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/season_detail', arguments: season);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.event, color: AppColors.primaryAuth),
                              const SizedBox(width: 12),

                              // ========== TEXT CONTENT ==========
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      season.name,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${season.startedAt} - ${season.endedAt ?? 'Sedang berlangsung'}",
                                      style: GoogleFonts.rubik(fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Status: ${season.status}",
                                      style: GoogleFonts.rubik(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
