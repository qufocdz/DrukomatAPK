import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/settings_page.dart';
import 'package:aplikacjadrukomat/globals.dart';

void main() {
  setUp(() {
    user = {
      'FirstName': 'John',
      'LastName': 'Doe',
      'contact': {
        'email': 'john@example.com',
        'phone': '123456789',
        'address': {
          'StreetAndNumber': 'Test Street 123',
        }
      }
    };
  });

  Widget createSettingsScreen() => MaterialApp(
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            body: settingsPage(context),
          ),
        ),
      );

  group('Settings Page UI Tests', () {
    testWidgets('Shows user information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('123456789'), findsOneWidget);
      expect(find.text('Test Street 123'), findsOneWidget);
    });

    testWidgets('Shows placeholder for missing information',
        (WidgetTester tester) async {
      user = {'FirstName': 'John', 'LastName': 'Doe', 'contact': {}};

      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Nie podano'), findsNWidgets(3));
    });

    testWidgets('Has correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(8));
    });

    testWidgets('Logout button is present and clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(createSettingsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Wyloguj się'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });
  });
}
