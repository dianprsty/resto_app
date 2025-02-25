import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail_response.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/static/restaurant_detail_result_state.dart';

class MockRestaurantDetailProvider extends Mock
    implements RestaurantDetailProvider {}

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockRestaurantDetailProvider mockRestaurantDetailProvider;
  late RestaurantDetailProvider restaurantDetailProvider;
  late MockApiServices mockApiServices;
  String id = "rqdv5juczeskfw1e867";

  Map<String, dynamic> mockDetailRestaurants = {
    "error": false,
    "message": "success",
    "restaurant": {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description":
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
      "city": "Medan",
      "address": "Jln. Pandeglang no 19",
      "pictureId": "14",
      "categories": [
        {"name": "Italia"},
        {"name": "Modern"}
      ],
      "menus": {
        "foods": [
          {"name": "Paket rosemary"},
          {"name": "Toastie salmon"}
        ],
        "drinks": [
          {"name": "Es krim"},
          {"name": "Sirup"}
        ]
      },
      "rating": 4.2,
      "customerReviews": [
        {
          "name": "Ahmad",
          "review": "Tidak rekomendasi untuk pelajar!",
          "date": "13 November 2019"
        }
      ]
    }
  };

  setUp(() {
    mockApiServices = MockApiServices();
    mockRestaurantDetailProvider = MockRestaurantDetailProvider();
    restaurantDetailProvider = RestaurantDetailProvider(mockApiServices);
  });

  group('Get Restaurant Detail Data', () {
    test('should return none state when provider initialize.', () {
      when(() => mockApiServices.getRestaurantDetail(id)).thenAnswer(
        (_) async => RestaurantDetailResponse.fromJson(mockDetailRestaurants),
      );
      final initState = restaurantDetailProvider.resultState;

      expect(initState, isA<RestaurantDetailNoneState>());
    });

    test('should return loaded state when success fetch data.', () async {
      when(() => mockApiServices.getRestaurantDetail(id)).thenAnswer(
        (_) async => RestaurantDetailResponse.fromJson(mockDetailRestaurants),
      );
      when(() => mockRestaurantDetailProvider.fetchRestaurantDetail(id))
          .thenAnswer((_) async => []);

      await restaurantDetailProvider.fetchRestaurantDetail(id);

      expect(restaurantDetailProvider.resultState,
          isA<RestaurantDetailLoadedState>());
    });

    test('should return error state when failed fetch data.', () async {
      when(() => mockApiServices.getRestaurantDetail(id)).thenAnswer(
        (_) async => throw Exception(),
      );
      when(() => mockRestaurantDetailProvider.fetchRestaurantDetail(id))
          .thenAnswer((_) async => []);

      await restaurantDetailProvider.fetchRestaurantDetail(id);

      expect(restaurantDetailProvider.resultState,
          isA<RestaurantDetailErrorState>());
    });

    test('should have restaurant detail when success fetch data.', () async {
      when(() => mockApiServices.getRestaurantDetail(id)).thenAnswer(
        (_) async => RestaurantDetailResponse.fromJson(mockDetailRestaurants),
      );

      when(() => mockRestaurantDetailProvider.fetchRestaurantDetail(id))
          .thenAnswer(
        (_) async => mockDetailRestaurants,
      );

      await restaurantDetailProvider.fetchRestaurantDetail(id);

      RestaurantDetail restaurantDetail =
          (restaurantDetailProvider.resultState as RestaurantDetailLoadedState)
              .data;

      expect(restaurantDetail, isA<RestaurantDetail>());
    });

    test('should have the expected restaurant name.', () async {
      when(() => mockApiServices.getRestaurantDetail(id)).thenAnswer(
        (_) async => RestaurantDetailResponse.fromJson(mockDetailRestaurants),
      );

      when(() => mockRestaurantDetailProvider.fetchRestaurantDetail(id))
          .thenAnswer(
        (_) async => mockDetailRestaurants,
      );

      await restaurantDetailProvider.fetchRestaurantDetail(id);

      RestaurantDetail restaurantDetail =
          (restaurantDetailProvider.resultState as RestaurantDetailLoadedState)
              .data;

      expect(restaurantDetail.name, "Melting Pot");
    });
  });
}
