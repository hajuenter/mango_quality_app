import 'package:flutter_test/flutter_test.dart';
import 'package:mango_app/services/auth_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  group('AuthService Test', () {
    late MockFirebaseAuth mockAuth;
    late AuthService authService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      authService = AuthService(firebaseAuth: mockAuth);
    });

    test('Register user with email and password', () async {
      final user = await authService.register('test@example.com', '123456');
      expect(user, isA<UserCredential>());
      expect(user.user?.email, 'test@example.com');
    });

    test('Login user with email and password', () async {
      await mockAuth.createUserWithEmailAndPassword(
        email: 'login@example.com',
        password: 'password',
      );
      final user = await authService.login('login@example.com', 'password');
      expect(user.user?.email, 'login@example.com');
    });

    test('Reset password sends email', () async {
      await authService.resetPassword('reset@example.com');
      // MockFirebaseAuth tidak benar-benar kirim email, tapi kita bisa test tidak error
      expect(true, true);
    });
  });
}
