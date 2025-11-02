class ErrorHandler {
  // Helper method untuk pesan error umum Firebase Auth
  static String getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan';
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter)';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan tunggu beberapa saat';
      case 'invalid-credential':
        return 'Email atau password salah';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  // Helper method khusus untuk error reset password
  static String getResetPasswordErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-not-found':
        return 'Email tidak terdaftar dalam sistem';
      case 'missing-email':
        return 'Email harus diisi';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
      case 'too-many-requests':
        return 'Terlalu banyak permintaan. Silakan tunggu beberapa saat.';
      case 'operation-not-allowed':
        return 'Reset password tidak diaktifkan. Hubungi administrator.';
      case 'invalid-continue-uri':
        return 'URL tidak valid';
      case 'unauthorized-continue-uri':
        return 'Domain URL tidak diizinkan';
      default:
        return 'Gagal mengirim email reset password. Silakan coba lagi.';
    }
  }

  // Helper method khusus untuk error register
  static String getRegisterErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'operation-not-allowed':
        return 'Registrasi email/password tidak diaktifkan';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah';
      default:
        return 'Registrasi gagal. Silakan coba lagi.';
    }
  }

  // Helper method khusus untuk error login
  static String getLoginErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun Anda telah dinonaktifkan. Hubungi administrator.';
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'invalid-credential':
        return 'Email atau password salah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah';
      default:
        return 'Login gagal. Silakan coba lagi.';
    }
  }
}
