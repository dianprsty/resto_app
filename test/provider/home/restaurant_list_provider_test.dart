import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/data/model/restaurant.dart';
import 'package:restauran_submission_1/data/model/restaurant_list_response.dart';
import 'package:restauran_submission_1/provider/home/restaurant_list_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restauran_submission_1/static/restaurant_list_result_state.dart';

class MockRestaurantListProvider extends Mock
    implements RestaurantListProvider {}

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockRestaurantListProvider mockRestaurantListProvider;
  late RestaurantListProvider restaurantListProvider;
  late MockApiServices mockApiServices;

  Map<String, dynamic> mockRestaurants = {
    "error": false,
    "message": "success",
    "count": 20,
    "restaurants": [
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
    ]
  };

  setUp(() {
    mockRestaurantListProvider = MockRestaurantListProvider();
    mockApiServices = MockApiServices();
    restaurantListProvider = RestaurantListProvider(mockApiServices);
  });

  group('Get Restaurant List Data', () {
    test('should return none state when provider initialize.', () {
      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => RestaurantListResponse.fromJson(mockRestaurants),
      );
      final initState = restaurantListProvider.resultState;

      expect(initState, isA<RestaurantListNoneState>());
    });

    test('should return loaded state when success fetch data.', () async {
      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => RestaurantListResponse.fromJson(mockRestaurants),
      );
      when(() => mockRestaurantListProvider.fetchRestaurantList())
          .thenAnswer((_) async => []);

      await restaurantListProvider.fetchRestaurantList();

      expect(
          restaurantListProvider.resultState, isA<RestaurantListLoadedState>());
    });

    test('should return error state when failed fetch data.', () async {
      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => throw Exception(),
      );
      when(() => mockRestaurantListProvider.fetchRestaurantList())
          .thenAnswer((_) async => []);

      await restaurantListProvider.fetchRestaurantList();

      expect(
          restaurantListProvider.resultState, isA<RestaurantListErrorState>());
    });

    test('should have restaurant list when success fetch data.', () async {
      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => RestaurantListResponse.fromJson(mockRestaurants),
      );
      when(() => mockRestaurantListProvider.fetchRestaurantList()).thenAnswer(
        (_) async => mockRestaurants,
      );

      await restaurantListProvider.fetchRestaurantList();

      List<Restaurant> restaurantList =
          (restaurantListProvider.resultState as RestaurantListLoadedState)
              .data;

      expect(restaurantList, isA<List<Restaurant>>());
    });

    test('should have 2 restaurant data when 2 data exist.', () async {
      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => RestaurantListResponse.fromJson(mockRestaurants),
      );

      when(() => mockRestaurantListProvider.fetchRestaurantList()).thenAnswer(
        (_) async => mockRestaurants,
      );

      await restaurantListProvider.fetchRestaurantList();

      List<Restaurant> restaurantList =
          (restaurantListProvider.resultState as RestaurantListLoadedState)
              .data;

      int totalData = restaurantList.length;

      expect(totalData, 2);
    });
  });
}
