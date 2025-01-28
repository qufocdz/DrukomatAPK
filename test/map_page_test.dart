import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/map_page.dart';
import 'package:aplikacjadrukomat/mongodb.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() {
  final mockDrukomats = [
    Drukomat(
        drukomatID: ObjectId.fromHexString('507f1f77bcf86cd799439011'),
        name: 'Test Drukomat 1',
        location: const LatLng(52.2297, 21.0122),
        address: 'Test Address 1',
        city: 'Warsaw',
        status: 1,
        description: 'Test Description 1'),
    Drukomat(
        drukomatID: ObjectId.fromHexString('507f1f77bcf86cd799439012'),
        name: 'Test Drukomat 2',
        location: const LatLng(52.2298, 21.0123),
        address: 'Test Address 2',
        city: 'Warsaw',
        status: 1,
        description: 'Test Description 2'),
  ];

  group('Map Display Tests', () {
    testWidgets('MapPage shows GoogleMap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapPage()));
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('Custom marker icon loads correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapPage()));
      await tester.pumpAndSettle();

      final mapPageState = tester.state<MapPageState>(find.byType(MapPage));
      final markers = mapPageState.markers;

      for (var marker in markers) {
        expect(marker.icon, isNotNull);
      }
    });
    testWidgets('Markers show correct info windows',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MapPage()));
      await tester.pumpAndSettle();

      final mapPageState = tester.state<MapPageState>(find.byType(MapPage));

      for (var drukomat in mockDrukomats) {
        mapPageState.setState(() {
          mapPageState.selectedDrukomat = drukomat;
        });
        await tester.pumpAndSettle();

        expect(find.text(drukomat.name), findsOneWidget);
        expect(find.text(drukomat.address!), findsOneWidget);
      }
    });
  });
}
