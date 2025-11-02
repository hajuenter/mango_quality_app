import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango_app/pages/auth/login_page.dart';

void main() {
  testWidgets('LoginPage has email and password fields and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    // Pastikan widget tampil
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
