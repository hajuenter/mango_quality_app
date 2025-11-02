import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../config/colors.dart';
import '../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      setState(() {
        _showShimmer = false; // matikan shimmer
      });

      Timer(const Duration(seconds: 3), () {
        Get.offAllNamed(AppRoutes.login);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final titleWidget = Text(
      'MANGO SORT',
      textAlign: TextAlign.center,
      style: GoogleFonts.rubik(
        fontSize: size.width * 0.09,
        fontWeight: FontWeight.bold,
        color: AppColors.textAuth,
        letterSpacing: 1.5,
      ),
    );

    final subtitleWidget = Text(
      'SMART SORTIR MANGGA',
      textAlign: TextAlign.center,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w500,
        fontSize: size.width * 0.04,
        color: AppColors.textAuth,
        letterSpacing: 1.2,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.primaryAuth,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo responsif
                Image.asset(
                  'assets/logo_splash.png',
                  width: size.width * 0.7,
                  height: size.height * 0.25,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: size.height * 0.02),

                _showShimmer
                    ? Shimmer.fromColors(
                        baseColor: Colors.white.withValues(alpha: 0.6),
                        highlightColor: Colors.white,
                        period: const Duration(seconds: 3),
                        child: titleWidget,
                      )
                    : titleWidget,

                SizedBox(height: size.height * 0.01),

                _showShimmer
                    ? Shimmer.fromColors(
                        baseColor: Colors.white.withValues(alpha: 0.7),
                        highlightColor: Colors.white,
                        period: const Duration(seconds: 2),
                        child: subtitleWidget,
                      )
                    : subtitleWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
