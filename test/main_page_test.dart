import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjadrukomat/main_page.dart';
import 'package:aplikacjadrukomat/globals.dart';

void main() {
  Widget createMainPage() => const MaterialApp(home: MainPage());

  group('MainPage Navigation Tests', () {
    testWidgets('Service user sees 4 pages and can swipe through them',
        (WidgetTester tester) async {
      service = true;
      await tester.pumpWidget(createMainPage());

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(4));

      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      final pageController =
          tester.widget<PageView>(find.byType(PageView)).controller;
      expect(pageController!.page, 1);

      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(pageController.page, 3);
    });

    testWidgets('Regular user sees only 2 pages and dots',
        (WidgetTester tester) async {
      service = false;
      await tester.pumpWidget(createMainPage());

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(2));

      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      final pageController =
          tester.widget<PageView>(find.byType(PageView)).controller;
      expect(pageController!.page, 1);
    });

    testWidgets('Settings button is present and clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(createMainPage());

      expect(find.byIcon(Icons.settings), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(Navigator), findsOneWidget);
    });
  });
}
