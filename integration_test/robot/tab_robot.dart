import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TabRobot {
  final WidgetTester tester;

  const TabRobot(this.tester);

  Future<void> checkHome() async {
    expect(find.text("Restaurants"), findsWidgets);
    expect(find.text("Melting Pot"), findsWidgets);
    await tester.pumpAndSettle();
  }

  Future<void> goToSearch() async {
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
  }

  Future<void> checkSearch() async {
    expect(find.byType(TextField), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> goToFavorite() async {
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
  }

  Future<void> checkFavorite() async {
    expect(find.text("Favorite Restaurants"), findsWidgets);
    await tester.pumpAndSettle();
  }

  Future<void> goToSetting() async {
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
  }

  Future<void> checkSetting() async {
    expect(find.text("Setting"), findsWidgets);
    await tester.pumpAndSettle();
  }
}
