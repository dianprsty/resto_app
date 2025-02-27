import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SearchRobot {
  final WidgetTester tester;

  const SearchRobot(this.tester);

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

  Future<void> fillSearchBar(String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  Future<void> checkSearchResult(String text) async {
    final searchresult = find.text(text);
    expect(searchresult, findsWidgets);
    await tester.tap(searchresult.last);
  }
}
