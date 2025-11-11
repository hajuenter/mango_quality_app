import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import '../../config/colors.dart';
import '../../widgets/custom_snackbar.dart';

class MusimStartPage extends StatefulWidget {
  const MusimStartPage({super.key});

  @override
  State<MusimStartPage> createState() => _MusimStartPageState();
}

class _MusimStartPageState extends State<MusimStartPage> {
  final TextEditingController _nameController = TextEditingController();

  void _saveSeason() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      CustomSnackbar.show(
        title: 'Peringatan',
        message: 'Nama musim tidak boleh kosong',
        textColor: Colors.white,
        backgroundColor: AppColors.redAuth,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    CustomSnackbar.show(
      title: 'Berhasil',
      message: 'Musim "$name" berhasil dibuat',
      backgroundColor: AppColors.borGreen,
      textColor: Colors.white,
      icon: Icons.check_circle_rounded,
      alignment: Alignment.topCenter,
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      Get.offAllNamed(AppRoutes.main, arguments: {'tabIndex': 0});
    });
  }

  void _goToDashboard() {
    Get.offAllNamed(AppRoutes.main, arguments: {'tabIndex': 0});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ), // lebih kecil
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
                    onPressed: _goToDashboard,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Setup Musim Baru',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 20, // lebih kecil
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40), // spasi untuk balance row
                ],
              ),
            ),

            // === BODY ===
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masukkan nama musim panen mangga Anda.',
                      style: GoogleFonts.rubik(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Musim',
                        labelStyle: GoogleFonts.rubik(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryAuth,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveSeason,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAuth,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Simpan Musim',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
