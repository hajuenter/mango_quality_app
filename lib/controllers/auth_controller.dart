import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/colors.dart';
import 'mango_statistic_controller.dart';

import '../helpers/validator.dart';
import '../responses/auth_response.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'nav_controller.dart';
import '../widgets/custom_snackbar.dart';
import '../controllers/mango_all_controller.dart';
import '../controllers/mango_latest_controller.dart';
import '../controllers/healthy_rotten_count_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController({AuthService? authService})
    : _authService = authService ?? AuthService();

  RxBool isLoading = false.obs;
  RxBool isResetLoading = false.obs;

  Future<void> register(
    String email,
    String password, {
    Function? onError,
  }) async {
    isLoading.value = true;
    try {
      AuthResponse res = await _authService.register(email, password);
      if (res.success) {
        Get.offAllNamed('/login', arguments: {'registered': true});
      } else {
        if (onError != null) onError();
        CustomSnackbar.show(
          title: 'Error',
          durationSeconds: 3,
          message: res.message ?? 'Registrasi gagal',
          icon: Icons.error_outline_rounded,
          backgroundColor: AppColors.redAuth,
        );
      }
    } catch (e) {
      if (onError != null) onError();
      CustomSnackbar.show(
        title: 'Error',
        durationSeconds: 3,
        message: 'Terjadi kesalahan koneksi. Periksa internet Anda.',
        icon: Icons.wifi_off_rounded,
        backgroundColor: AppColors.redAuth,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password, {Function? onError}) async {
    isLoading.value = true;
    try {
      AuthResponse res = await _authService.login(email, password);
      if (res.success) {
        final user = FirebaseAuth.instance.currentUser;
        final idToken = await user?.getIdToken();
        debugPrint("🔥 Firebase ID Token: $idToken");

        // Reset nav controller
        final navController = Get.find<NavController>();
        navController.changeTab(0);

        // Navigasi ke halaman utama
        Get.offAllNamed(AppRoutes.main);

        // Tampilkan snackbar setelah frame berikutnya
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomSnackbar.show(
            title: 'Berhasil',
            durationSeconds: 3,
            message: 'Selamat datang kembali!',
            backgroundColor: AppColors.borGreen,
            icon: Icons.check_circle_outline_rounded,
          );
        });
      } else {
        if (onError != null) onError();
        CustomSnackbar.show(
          title: 'Error',
          durationSeconds: 3,
          message: res.message ?? 'Login gagal',
          backgroundColor: AppColors.redAuth,
          icon: Icons.error_outline_rounded,
        );
      }
    } catch (e) {
      if (onError != null) onError();
      CustomSnackbar.show(
        title: 'Error',
        durationSeconds: 3,
        message: 'Terjadi kesalahan koneksi. Periksa internet Anda.',
        icon: Icons.wifi_off_rounded,
        backgroundColor: AppColors.redAuth,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    if (Validator.isEmailEmpty(email)) {
      CustomSnackbar.show(
        title: 'Error',
        durationSeconds: 3,
        message: 'Email tidak boleh kosong',
        icon: Icons.error_outline_rounded,
        backgroundColor: AppColors.redAuth,
      );
      return;
    }

    isResetLoading.value = true;

    try {
      AuthResponse res = await _authService.resetPassword(email);
      if (res.success) {
        CustomSnackbar.show(
          title: 'Berhasil',
          durationSeconds: 3,
          message: res.message ?? 'Email reset password telah dikirim',
          backgroundColor: AppColors.borGreen,
          icon: Icons.email_outlined,
        );
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else {
        CustomSnackbar.show(
          title: 'Error',
          durationSeconds: 3,
          message: res.message ?? 'Gagal mengirim email reset password',
          icon: Icons.error_outline_rounded,
          backgroundColor: AppColors.redAuth,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        durationSeconds: 3,
        message: 'Terjadi kesalahan koneksi. Periksa internet Anda.',
        icon: Icons.wifi_off_rounded,
        backgroundColor: AppColors.redAuth,
      );
    } finally {
      isResetLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    // atau
    // Get.deleteAll(force: true);
    try {
      Get.delete<MangoAllController>();
      Get.delete<MangoLatestController>();
      Get.delete<MangoStatisticController>();
      Get.delete<HealthyRottenCountController>();
    } catch (e) {
      debugPrint('⚠️ Gagal hapus controller: $e');
    }

    await _authService.logout();

    isLoading.value = false;
    Get.offAllNamed('/login');
  }
}
