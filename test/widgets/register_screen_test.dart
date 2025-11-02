import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango_app/pages/auth/register_page.dart';

void main() {
  testWidgets('RegisterPage has email, password and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: RegisterPage()));

    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
