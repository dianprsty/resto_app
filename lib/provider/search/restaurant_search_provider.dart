import 'package:flutter/material.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/static/restaurant_search_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  String _searchQuery = "";

  RestaurantSearchProvider(this._apiServices);

  RestaurantSearchResultState _resultState = RestaurantSearchNoneState();

  RestaurantSearchResultState get resultState => _resultState;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String get query => _searchQuery;

  Future<void> searchRestaurant() async {
    try {
      _resultState = RestaurantSearchLoadingState();
      notifyListeners();

      final result = await _apiServices.searchRestaurant(_searchQuery);

      if (result.error) {
        _resultState = RestaurantSearchErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantSearchLoadedState(result.restaurants);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantSearchErrorState(
          e.toString().replaceFirst("Exception: ", ""));
      notifyListeners();
    }
  }
}
