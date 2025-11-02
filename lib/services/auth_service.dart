import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/error_handler.dart';
import '../helpers/validator.dart';
import '../models/user_model.dart';
import '../responses/auth_response.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AuthResponse> register(String email, String password) async {
    try {
      // Validasi input
      final emailError = Validator.getEmailError(email);
      if (emailError != null) {
        return AuthResponse(success: false, message: emailError);
      }

      final passwordError = Validator.getPasswordError(password);
      if (passwordError != null) {
        return AuthResponse(success: false, message: passwordError);
      }

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = UserModel(uid: cred.user!.uid, email: cred.user!.email!);
      return AuthResponse(success: true, user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
        success: false,
        message: ErrorHandler.getRegisterErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga',
      );
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      // Validasi input
      final emailError = Validator.getEmailError(email);
      if (emailError != null) {
        return AuthResponse(success: false, message: emailError);
      }

      final passwordError = Validator.getLoginPasswordError(password);
      if (passwordError != null) {
        return AuthResponse(success: false, message: passwordError);
      }

      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = UserModel(uid: cred.user!.uid, email: cred.user!.email!);
      return AuthResponse(success: true, user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
        success: false,
        message: ErrorHandler.getLoginErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga',
      );
    }
  }

  Future<AuthResponse> resetPassword(String email) async {
    try {
      // Validasi email
      final emailError = Validator.getEmailError(email);
      if (emailError != null) {
        return AuthResponse(success: false, message: emailError);
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResponse(
        success: true,
        message: "Link reset password berhasil dikirim",
      );
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
        success: false,
        message: ErrorHandler.getResetPasswordErrorMessage(e.code),
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
