import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mango_app/controllers/auth_controller.dart';
import 'package:mango_app/services/auth_service.dart';
import 'package:mango_app/responses/auth_response.dart';
import 'package:mango_app/models/user_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthController controller;
  late MockAuthService mockService;

  setUp(() {
    Get.testMode = true; // disable snackbar overlay behaviour
    mockService = MockAuthService();
    controller = AuthController(authService: mockService);
  });

  group('AuthController', () {
    test(
      'register success calls service and sets isLoading correctly',
      () async {
        final fakeUser = UserModel(uid: 'u1', email: 'test@example.com');
        when(
          () => mockService.register(any(), any()),
        ).thenAnswer((_) async => AuthResponse(success: true, user: fakeUser));

        await controller.register('test@example.com', '123456');

        verify(
          () => mockService.register('test@example.com', '123456'),
        ).called(1);
        expect(controller.isLoading.value, false);
      },
    );

    test(
      'register failure shows error (service returns success=false)',
      () async {
        when(
          () => mockService.register(any(), any()),
        ).thenAnswer((_) async => AuthResponse(success: false, message: 'err'));

        await controller.register('test@example.com', '123456');

        verify(
          () => mockService.register('test@example.com', '123456'),
        ).called(1);
        expect(controller.isLoading.value, false);
      },
    );

    test('login success', () async {
      final fakeUser = UserModel(uid: 'u2', email: 'login@example.com');
      when(
        () => mockService.login(any(), any()),
      ).thenAnswer((_) async => AuthResponse(success: true, user: fakeUser));

      await controller.login('login@example.com', '123456');

      verify(() => mockService.login('login@example.com', '123456')).called(1);
      expect(controller.isLoading.value, false);
    });

    test('resetPassword success', () async {
      when(
        () => mockService.resetPassword(any()),
      ).thenAnswer((_) async => AuthResponse(success: true, message: 'Sent'));

      await controller.resetPassword('reset@example.com');

      verify(() => mockService.resetPassword('reset@example.com')).called(1);
    });

    test('logout calls service.logout', () async {
      when(() => mockService.logout()).thenAnswer((_) async {});

      await controller.logout();

      verify(() => mockService.logout()).called(1);
    });
  });
}
