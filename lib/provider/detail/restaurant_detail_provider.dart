import 'package:flutter/widgets.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/static/restaurant_detail_result_state.dart';

enum MenuType {
  food,
  drink,
}

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();
  bool _isExpandedAbout = false;
  bool _isExpandedMenu = false;
  bool _isExpandedndedReview = false;
  MenuType _menuType = MenuType.food;

  RestaurantDetailProvider(
    this._apiServices,
  );

  RestaurantDetailResultState get resultState => _resultState;

  bool get isExpandedAbout => _isExpandedAbout;

  bool get isExpandedAMenu => _isExpandedMenu;

  bool get isExpandedReview => _isExpandedndedReview;

  MenuType get menuType => _menuType;

  void toggleExpandedAbout() {
    _isExpandedAbout = !_isExpandedAbout;
    notifyListeners();
  }

  void toggleExpandedMenu() {
    _isExpandedMenu = !_isExpandedMenu;
    notifyListeners();
  }

  void toggleExpandedReview() {
    _isExpandedndedReview = !_isExpandedndedReview;
    notifyListeners();
  }

  void setMenuType(MenuType menuType) {
    _menuType = menuType;
    notifyListeners();
  }

  resetExpanded() {
    _isExpandedAbout = false;
    _isExpandedMenu = false;
    _isExpandedndedReview = false;
    _menuType = MenuType.food;
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantDetail(id);

      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantDetailErrorState(
          e.toString().replaceFirst("Exception: ", ""));
      notifyListeners();
    }
  }
}
