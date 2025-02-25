import 'package:flutter/widgets.dart';
import 'package:restauran_submission_1/data/model/restaurant.dart';
import 'package:restauran_submission_1/services/sqlite_service.dart';
import 'package:restauran_submission_1/static/restaurant_list_result_state.dart';

class FavoriteRestaurantProvider extends ChangeNotifier {
  final SqliteService _service;

  FavoriteRestaurantProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  RestaurantListResultState _resultState = RestaurantListLoadingState();
  RestaurantListResultState get resultState => _resultState;

  Future<void> saveRestaurant(Restaurant value) async {
    try {
      final result = await _service.insertItem(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        getAllRestaurant();
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> getAllRestaurant() async {
    try {
      _resultState = RestaurantListLoadingState();
      _restaurantList = await _service.getAllItems();
      _message = "All of your data is loaded";
      _resultState = RestaurantListLoadedState(_restaurantList!);
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your all data";
      _resultState = RestaurantListErrorState("Failed to load favorite data");
      notifyListeners();
    }
  }

  Future<void> getRestaurantById(String id) async {
    try {
      _restaurant = await _service.getItemById(id);
      _message = "Your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your data";
      notifyListeners();
    }
  }

  Future<void> removeRestaurant(String id) async {
    try {
      await _service.removeItem(id);

      _message = "Your data is removed";
      _restaurant = null;
      getAllRestaurant();
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }
}
