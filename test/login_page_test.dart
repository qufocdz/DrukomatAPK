import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/login_page.dart';
import 'package:aplikacjadrukomat/mongodb.dart';

void main() {
  Widget createLoginScreen() => const MaterialApp(home: LoginPage());

  group('Login Form Tests', () {
    test('Hash is consistent for same password', () {
      final password = 'TestPassword123';
      final hash1 = hashPassword(password);
      final hash2 = hashPassword(password);
      expect(hash1, equals(hash2));
    });

    test('Different passwords produce different hashes', () {
      final hash1 = hashPassword('password1');
      final hash2 = hashPassword('password2');
      expect(hash1, isNot(equals(hash2)));
    });

    testWidgets('Shows error dialog for empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.tap(find.text('Zaloguj'));
      await tester.pumpAndSettle();

      expect(find.text('Błąd'), findsOneWidget);
      expect(find.text('Wprowadź zarówno email, jak i hasło.'), findsOneWidget);
    });

    testWidgets('Shows error for invalid credentials',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
          find.widgetWithText(TextField, 'Email'), 'wrong@test.com');
      await tester.enterText(
          find.widgetWithText(TextField, 'Hasło'), 'wrongpass');

      await tester.tap(find.text('Zaloguj'));
      await tester.pumpAndSettle();

      expect(find.text('Błąd'), findsOneWidget);
      expect(find.text('Nieprawidłowy email lub hasło.'), findsOneWidget);
    });

    testWidgets('Navigates to register page', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.tap(
          find.text('Nie masz konta? Kliknij tutaj, aby się zarejestrować.'));
      await tester.pumpAndSettle();

      expect(find.text('Rejestracja'), findsOneWidget);
    });
  });
}
