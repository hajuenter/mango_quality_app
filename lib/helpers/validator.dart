class Validator {
  // Validasi email
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Validasi password
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    return hasLetter && hasNumber && hasSymbol;
  }

  // Validasi email kosong
  static bool isEmailEmpty(String email) {
    return email.trim().isEmpty;
  }

  // Validasi password kosong
  static bool isPasswordEmpty(String password) {
    return password.trim().isEmpty;
  }

  // Get pesan error untuk email
  static String? getEmailError(String email) {
    if (isEmailEmpty(email)) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Get pesan error untuk password
  static String? getPasswordError(String password) {
    if (isPasswordEmpty(password)) {
      return 'Password tidak boleh kosong';
    }
    if (!isValidPassword(password)) {
      if (password.length < 8) {
        return 'Password minimal 8 karakter';
      }
      return 'Password harus kombinasi huruf, angka, dan simbol';
    }
    return null;
  }

  // Validasi form register
  static Map<String, String?> validateRegisterForm({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'email': getEmailError(email),
      'password': getPasswordError(password),
      'confirmPassword': password != confirmPassword
          ? 'Password tidak cocok'
          : null,
    };
  }

  // Validasi form login
  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': getEmailError(email),
      'password': getPasswordError(password),
    };
  }

  // Validasi password untuk login (lebih sederhana)
  static String? getLoginPasswordError(String password) {
    if (isPasswordEmpty(password)) {
      return 'Password tidak boleh kosong';
    }
    return null; // tidak perlu cek panjang atau simbol
  }
}
