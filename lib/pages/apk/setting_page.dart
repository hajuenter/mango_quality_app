import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/expanded_menu.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();

  // kontrol expand tiap menu
  bool _isAboutExpanded = false;
  bool _isPrivacyExpanded = false;
  bool _isGuideExpanded = false;
  bool _isFeedbackExpanded = false;
  bool _isChatbotExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primaryAuth,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'Pengaturan',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card Logo
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/logo_splash.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'MANGO SORT',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SMART SORTIR MANGGA',
                              style: GoogleFonts.rubik(
                                fontSize: 8,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Card Menu
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // --- Tentang Aplikasi ---
                          ExpandedMenu(
                            icon: Icons.info_outline_rounded,
                            title: 'Tentang Aplikasi',
                            isExpanded: _isAboutExpanded,
                            onTap: () {
                              setState(() {
                                _isAboutExpanded = !_isAboutExpanded;
                              });
                            },
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Versi: 1.0.0',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Pengembang: Tim MangoSort',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '''Aplikasi ini merupakan sistem monitoring pintar yang terhubung dengan perangkat IoT untuk proses penyortiran buah mangga. 
Dengan algoritma machine learning K-Nearest Neighbors (KNN), sistem mampu mendeteksi kondisi mangga sehat atau busuk, secara otomatis dan akurat.''',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),

                          // --- Kebijakan Privasi ---
                          ExpandedMenu(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Kebijakan Privasi',
                            isExpanded: _isPrivacyExpanded,
                            onTap: () {
                              setState(() {
                                _isPrivacyExpanded = !_isPrivacyExpanded;
                              });
                            },
                            content: Text(
                              'Data pengguna disimpan secara lokal dan tidak dibagikan ke pihak ketiga tanpa izin.',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const Divider(height: 1),

                          // --- Panduan Penggunaan ---
                          ExpandedMenu(
                            icon: Icons.help_outline_rounded,
                            title: 'Panduan Penggunaan',
                            isExpanded: _isGuideExpanded,
                            onTap: () {
                              setState(() {
                                _isGuideExpanded = !_isGuideExpanded;
                              });
                            },
                            content: Text(
                              '1. Pastikan perangkat keras terhubung dan aktif.\n'
                              '2. Mulai atau akhiri musim melalui menu Beranda.\n'
                              '3. Pantau hasil deteksi secara real-time di halaman Aktivitas.\n'
                              '4. Lihat statistik panen di menu Statistik.\n'
                              '5. Unduh laporan PDF pada menu Laporan atau detail musim.',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const Divider(height: 1),

                          ExpandedMenu(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: 'Asisten Pintar',
                            isExpanded: _isChatbotExpanded,
                            onTap: () {
                              setState(() {
                                _isChatbotExpanded = !_isChatbotExpanded;
                              });
                            },
                            content: Text(
                              'Gunakan Asisten Pintar untuk bertanya seputar cara kerja sistem, '
                              'perbedaan mangga sehat dan busuk, atau panduan penggunaan MangoSort. '
                              'Asisten ini akan membantu Anda secara interaktif menggunakan kecerdasan buatan.',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const Divider(height: 1),

                          ExpandedMenu(
                            icon: Icons.star_border_rounded,
                            title: 'Penilaian & Saran',
                            isExpanded: _isFeedbackExpanded,
                            onTap: () {
                              setState(() {
                                _isFeedbackExpanded = !_isFeedbackExpanded;
                              });
                            },
                            content: Text(
                              'Masukan Anda sangat berharga bagi kami.\nSilakan kirim saran atau pertanyaan ke: support@mangosort.app',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const Divider(height: 1),
                          // --- Logout ---
                          InkWell(
                            splashColor:
                                Colors.transparent, // Hilangkan efek cipratan
                            highlightColor:
                                Colors.transparent, // Hilangkan efek tekan
                            hoverColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // supaya tidak ketutup jika klik luar modal
                                builder: (_) {
                                  return CustomModal(
                                    imageAsset: 'assets/logo_splash.png',
                                    icon: null,
                                    iconColor: Colors.red,
                                    title: 'Keluar Aplikasi?',
                                    message:
                                        'Apakah Anda yakin ingin keluar dari aplikasi MangoSort?',

                                    cancelText: 'Batal',
                                    confirmText: 'Keluar',

                                    onCancel: () {
                                      Navigator.pop(context); // menutup modal
                                    },

                                    onConfirm: () async {
                                      Navigator.pop(
                                        context,
                                      ); // tutup modal dulu
                                      await _authController
                                          .logout(); // jalankan logout
                                    },
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Keluar',
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
