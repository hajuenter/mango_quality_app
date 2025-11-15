import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/nav_controller.dart';
import '../config/colors.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final NavController navController = Get.find<NavController>();

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.insights_rounded,
    Icons.bar_chart_rounded,
    Icons.receipt_long_rounded,
    Icons.smart_toy_rounded,
    Icons.settings_rounded,
  ];

  final List<String> labels = const [
    "Beranda",
    "Aktivitas",
    "Statistik",
    "Riwayat",
    "Mango AI",
    "Pengaturan",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(icons.length, (index) {
              final isActive = navController.currentIndex.value == index;

              return GestureDetector(
                onTap: () => navController.changeTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  transform: isActive
                      ? Matrix4.translationValues(
                          0,
                          -10,
                          0,
                        ) // efek melayang ke atas
                      : Matrix4.identity(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // === Garis aktif di atas ikon ===
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 3,
                        width: 24,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryAuth
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // === Ikon ===
                      Icon(
                        icons[index],
                        color: isActive ? AppColors.primaryAuth : Colors.grey,
                        size: 28,
                      ),

                      const SizedBox(height: 3),

                      // === Label ===
                      AnimatedOpacity(
                        opacity: isActive ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          labels[index],
                          style: GoogleFonts.rubik(
                            fontSize: 10,
                            color: isActive
                                ? AppColors.primaryAuth
                                : Colors.transparent,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
