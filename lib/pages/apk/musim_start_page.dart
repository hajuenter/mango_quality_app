import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import '../../config/colors.dart';
import '../../widgets/custom_snackbar.dart';
import '../../controllers/season_crud_controller.dart';

class MusimStartPage extends StatefulWidget {
  const MusimStartPage({super.key});

  @override
  State<MusimStartPage> createState() => _MusimStartPageState();
}

class _MusimStartPageState extends State<MusimStartPage> {
  final SeasonCrudController controller = Get.put(SeasonCrudController());
  final TextEditingController _nameController = TextEditingController();

  void _saveSeason() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      CustomSnackbar.show(
        title: 'Peringatan',
        message: 'Nama musim tidak boleh kosong',
        backgroundColor: AppColors.redAuth,
        textColor: Colors.white,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    final msg = await controller.startSeason(name);

    if (msg != null) {
      CustomSnackbar.show(
        title: "Gagal",
        message: msg,
        backgroundColor: AppColors.redAuth,
        textColor: Colors.white,
        icon: Icons.error,
      );
      return;
    }

    CustomSnackbar.show(
      title: "Berhasil",
      message: 'Musim "$name" dimulai.',
      backgroundColor: AppColors.borGreen,
      textColor: Colors.white,
      icon: Icons.check_circle_rounded,
    );
  }

  void _navigateToDashboard() {
    Get.toNamed(AppRoutes.main, arguments: {'tabIndex': 0});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
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
                    onPressed: _navigateToDashboard,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mulai Musim Baru',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final active = controller.activeSeason.value;

                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (active == null) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 28,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Tidak ada musim aktif",
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAuth.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.eco_rounded,
                                size: 32,
                                color: AppColors.primaryAuth.withAlpha(204),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    active.name,
                                    style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "Status: Aktif",
                                    style: GoogleFonts.rubik(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tombol stop
                            IconButton(
                              icon: const Icon(
                                Icons.stop_circle_rounded,
                                color: Colors.red,
                                size: 34,
                              ),
                              onPressed: () async {
                                final msg = await controller.stopSeason();
                                if (msg != null) {
                                  CustomSnackbar.show(
                                    title: "Gagal",
                                    message: msg,
                                    backgroundColor: AppColors.redAuth,
                                    textColor: Colors.white,
                                    icon: Icons.error,
                                  );
                                } else {
                                  CustomSnackbar.show(
                                    title: "Berhasil",
                                    message: "Musim dihentikan.",
                                    backgroundColor: AppColors.borGreen,
                                    textColor: Colors.white,
                                    icon: Icons.check_circle_rounded,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Musim',
                        labelStyle: GoogleFonts.rubik(),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primaryAuth,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _saveSeason,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAuth,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Simpan Musim',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
