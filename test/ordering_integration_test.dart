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

      expect(find.text('Twój koszyk jest pusty.'), findsOneWidget);

      final scrollFinder = find.byType(SingleChildScrollView);
      expect(scrollFinder, findsOneWidget);

      await tester.dragUntilVisible(
        find.text('Dodaj do zamówienia'),
        scrollFinder,
        const Offset(0, -100),
      );
      expect(find.text('Dodaj do zamówienia'), findsOneWidget);

      await tester.tap(find.text('Dodaj do zamówienia'));
      await tester.pumpAndSettle();

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

      await tester.dragUntilVisible(
        find.text('Wydruk w kolorze:'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      expect(find.text('Wydruk w kolorze:'), findsOneWidget);

      expect(find.text('Format:'), findsOneWidget);
      expect(find.text('Liczba kopii:'), findsOneWidget);

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('A4'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A3').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.textContaining('zł'), findsOneWidget);

      await tester.tap(find.text('Dodaj do koszyka'));
      await tester.pumpAndSettle();

      expect(find.text('Koszyk jest pusty'), findsNothing);
      expect(find.text('Zapłać za zamówienie'), findsOneWidget);
    });
  });
}
