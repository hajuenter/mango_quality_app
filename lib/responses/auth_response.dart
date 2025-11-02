import '../models/user_model.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final UserModel? user;

  AuthResponse({required this.success, this.message, this.user});
}
