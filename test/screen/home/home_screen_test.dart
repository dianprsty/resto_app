import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/data/model/restaurant.dart';
import 'package:restauran_submission_1/provider/home/restaurant_list_provider.dart';
import 'package:restauran_submission_1/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/static/restaurant_list_result_state.dart';
import 'package:restauran_submission_1/widget/restaurant_card_widget.dart';

class MockRestaurantListProvider extends Mock
    implements RestaurantListProvider {}

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockRestaurantListProvider mockRestaurantListProvider;
  late Widget widget;

  List<Restaurant> mockRestaurants = [
    {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description":
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
      "pictureId": "14",
      "city": "Medan",
      "rating": 4.2
    },
    {
      "id": "s1knt6za9kkfw1e867",
      "name": "Kafe Kita",
      "description":
          "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
      "pictureId": "25",
      "city": "Gorontalo",
      "rating": 4
    }
  ].map((e) => Restaurant.fromMap(e)).toList();

  setUp(() {
    mockRestaurantListProvider = MockRestaurantListProvider();
    widget = MaterialApp(
      home: ChangeNotifierProvider<RestaurantListProvider>(
        create: (context) => mockRestaurantListProvider,
        child: const HomeScreen(),
      ),
    );
  });

  group("home screen", () {
    testWidgets("should have app bar", (tester) async {
      when(() => mockRestaurantListProvider.resultState).thenReturn(
        RestaurantListLoadedState(mockRestaurants),
      );

      when(() => mockRestaurantListProvider.fetchRestaurantList()).thenAnswer(
        (_) => Future.value(),
      );

      await mockNetworkImages(() async => tester.pumpWidget(widget));

      final appBarFinder = find.byType(AppBar);

      expect(appBarFinder, findsOneWidget);

      final textInAppBarFinder = find.descendant(
        of: appBarFinder,
        matching: find.byType(Text),
      );
      final textInAppBar = tester.widget<Text>(textInAppBarFinder);
      expect(textInAppBar.data, "Restaurants");
    });

    testWidgets("should show 2 restaurant card when have 2 restaurant data",
        (tester) async {
      when(() => mockRestaurantListProvider.resultState).thenReturn(
        RestaurantListLoadedState(mockRestaurants),
      );

      when(() => mockRestaurantListProvider.fetchRestaurantList()).thenAnswer(
        (_) => Future.value(),
      );

      await mockNetworkImages(() async => tester.pumpWidget(widget));

      final restaurantCardFinder = find.byType(RestaurantCard);

      expect(restaurantCardFinder, findsExactly(2));
    });
  });
}
