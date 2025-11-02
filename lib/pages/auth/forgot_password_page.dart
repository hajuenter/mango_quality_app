import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    FocusScope.of(context).unfocus();
    Get.offNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primaryAuth,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo_splash.png',
                            width: size.width * 0.45,
                            height: size.height * 0.15,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MANGO SORT',
                            style: GoogleFonts.rubik(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAuth,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reset Kata Sandi',
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    Text(
                      'Email',
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    CustomTextField(
                      controller: emailC,
                      hint: 'Masukkan email terdaftar',
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Obx(
                        () => SizedBox(
                          width: size.width * 0.5,
                          child: CustomButton(
                            label: 'Kirim Tautan',
                            isBold: true,
                            fontSize: 18,
                            loading: authC.isResetLoading.value,
                            color: AppColors.primaryAuth,
                            textColor: Colors.white,
                            onPressed: () =>
                                authC.resetPassword(emailC.text.trim()),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ingat kata sandi Anda? ',
                          style: GoogleFonts.rubik(fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: _navigateToLogin,
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryAuth,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
