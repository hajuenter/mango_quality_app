import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../config/colors.dart';

class MusimIntroPage extends StatefulWidget {
  const MusimIntroPage({super.key});

  @override
  State<MusimIntroPage> createState() => _MusimIntroPageState();
}

class _MusimIntroPageState extends State<MusimIntroPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Atur Musim Panenmu',
      'desc':
          'Kelola dan pantau musim panen mangga agar proses sortir lebih efisien, sehingga kamu dapat memaksimalkan hasil panen setiap musim.',
      'icon': Icons.calendar_month_rounded,
    },
    {
      'title': 'Catat Hasil Panen',
      'desc':
          'Setiap deteksi selama musim panen akan tersimpan secara otomatis, sehingga kamu bisa melacak kualitas dan jumlah mangga yang dipanen.',
      'icon': Icons.edit_document,
    },
    {
      'title': 'Analisis Produktivitas',
      'desc':
          'Lihat statistik performa tiap musim, termasuk jumlah mangga sehat dan busuk, untuk meningkatkan kualitas panen di musim berikutnya.',
      'icon': Icons.bar_chart_rounded,
    },
    {
      'title': 'Pantau Aktivitas Real-Time',
      'desc':
          'Dapatkan informasi secara langsung mengenai proses sortir mangga, sehingga kamu bisa segera mengambil tindakan jika ada masalah.',
      'icon': Icons.analytics_rounded,
    },
    {
      'title': 'Optimalkan Proses Sortir',
      'desc':
          'Gunakan data yang tercatat untuk mengoptimalkan jalur sortir, waktu kerja, dan kualitas mangga, sehingga proses lebih cepat dan akurat.',
      'icon': Icons.track_changes_rounded,
    },
  ];

  void _navigateToMusimStart() {
    FocusScope.of(context).unfocus();
    Get.toNamed('/musim_start');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAuth.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide['icon'],
                            size: 50,
                            color: AppColors.primaryAuth,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide['title']!,
                          style: GoogleFonts.rubik(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['desc']!,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SmoothPageIndicator(
                controller: _controller,
                count: slides.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primaryAuth,
                  dotColor: Colors.grey.shade300,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (currentIndex == slides.length - 1) {
                    _navigateToMusimStart();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAuth,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentIndex == slides.length - 1
                      ? 'Mulai Setup Musim'
                      : 'Lanjut',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (currentIndex < slides.length - 1)
                TextButton(
                  onPressed: () {
                    _controller.jumpToPage(slides.length - 1);
                  },
                  child: Text(
                    'Lewati',
                    style: GoogleFonts.rubik(color: Colors.grey.shade700),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
