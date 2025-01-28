import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/ordering_page.dart';
import 'package:aplikacjadrukomat/add_to_order_page.dart';
import 'package:aplikacjadrukomat/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  final mockDrukomat = Drukomat(
      drukomatID: mongo.ObjectId.fromHexString('507f1f77bcf86cd799439011'),
      name: 'Test Drukomat',
      location: const LatLng(52.2297, 21.0122),
      address: 'Test Address',
      city: 'Warsaw',
      status: 1,
      description: 'Test Description');

  group('Ordering Flow Integration Tests', () {
    testWidgets('Complete ordering flow test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: OrderingPage(drukomat: mockDrukomat),
      ));
      await tester.pumpAndSettle();

      // Verify initial OrderingPage state
      expect(find.text('Twój koszyk jest pusty.'), findsOneWidget);

      // Find the scrollable
      final scrollFinder = find.byType(SingleChildScrollView);
      expect(scrollFinder, findsOneWidget);

      // Scroll to and verify "Dodaj do zamówienia" button
      await tester.dragUntilVisible(
        find.text('Dodaj do zamówienia'),
        scrollFinder,
        const Offset(0, -100),
      );
      expect(find.text('Dodaj do zamówienia'), findsOneWidget);

      // Navigate to AddToOrderPage
      await tester.tap(find.text('Dodaj do zamówienia'));
      await tester.pumpAndSettle();

      // Scroll and verify AddToOrderPage elements
      await tester.dragUntilVisible(
        find.text('Dodaj własny druk'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      expect(find.text('Dodaj własny druk'), findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Dodaj druk z szablonu'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      expect(find.text('Dodaj druk z szablonu'), findsOneWidget);

      // Scroll to and verify print settings
      await tester.dragUntilVisible(
        find.text('Wydruk w kolorze:'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      expect(find.text('Wydruk w kolorze:'), findsOneWidget);

      // Test print settings
      expect(find.text('Format:'), findsOneWidget);
      expect(find.text('Liczba kopii:'), findsOneWidget);

      // Change print settings
      await tester.tap(find.byType(Switch).first); // Toggle color print
      await tester.pumpAndSettle();

      // Select format
      await tester.tap(find.text('A4'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A3').last);
      await tester.pumpAndSettle();

      // Change copies
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify price calculation
      expect(find.textContaining('zł'), findsOneWidget);

      // Add to basket
      await tester.tap(find.text('Dodaj do koszyka'));
      await tester.pumpAndSettle();

      // Back in OrderingPage, verify basket
      expect(find.text('Koszyk jest pusty'), findsNothing);
      expect(find.text('Zapłać za zamówienie'), findsOneWidget);
    });
  });
}
