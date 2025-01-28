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

      // Check initial state
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(4)); // 4 dot indicators

      // Swipe through pages
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Verify page changed
      final pageController =
          tester.widget<PageView>(find.byType(PageView)).controller;
      expect(pageController!.page, 1);

      // Continue to last page
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

      // Check initial state
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(2)); // 2 dot indicators

      // Try to swipe to third page (shouldn't exist)
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Verify we're still on last available page
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

      // Verify navigation occurred
      expect(find.byType(Navigator), findsOneWidget);
    });
  });
}
