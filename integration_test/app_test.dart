import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restauran_submission_1/main.dart' as app;

import 'robot/search_robot.dart';
import 'robot/tab_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("search restaurant", (tester) async {
    final searchRobot = SearchRobot(tester);

    app.main();
    await tester.pumpAndSettle(Duration(seconds: 5));

    await searchRobot.goToSearch();
    await searchRobot.checkSearch();

    await searchRobot.fillSearchBar("Melting Pot");
    await searchRobot.checkSearchResult("Melting Pot");
  });

  testWidgets("move page using bottom navigation bar", (tester) async {
    final tabRobot = TabRobot(tester);

    app.main();
    await tester.pumpAndSettle(Duration(seconds: 5));

    await tabRobot.checkHome();

    await tabRobot.goToSearch();
    await tabRobot.checkSearch();

    await tabRobot.goToFavorite();
    await tabRobot.checkFavorite();

    await tabRobot.goToSetting();
    await tabRobot.checkSetting();
  });
}
