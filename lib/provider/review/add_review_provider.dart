import 'package:flutter/material.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/static/add_review_result_state.dart';

class AddReviewProvider extends ChangeNotifier {
  final ApiServices _apiServices;
  String _id = "";
  String _name = "";
  String _review = "";

  AddReviewProvider(this._apiServices);

  AddReviewResultState _resultState = AddReviewNoneState();

  AddReviewResultState get resultState => _resultState;

  String get id => _id;

  String get name => _name;

  String get review => _review;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set review(String review) {
    _review = review;
    notifyListeners();
  }

  set id(String id) {
    _id = id;
    notifyListeners();
  }

  void reset() {
    _id = "";
    _name = "";
    _review = "";
    _resultState = AddReviewNoneState();
    notifyListeners();
  }

  void removeError() {
    if (_resultState is AddReviewErrorState) {
      _resultState = AddReviewNoneState();
      notifyListeners();
    }
  }

  Future<void> addReview() async {
    try {
      _resultState = AddReviewLoadingState();
      notifyListeners();

      final result = await _apiServices.addReview(_id, _name, _review);

      if (result.error) {
        _resultState = AddReviewErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = AddReviewLoadedState(result.customerReviews);
        _name = "";
        _review = "";
        notifyListeners();
      }
    } catch (e) {
      _resultState =
          AddReviewErrorState(e.toString().replaceFirst("Exception: ", ""));
      notifyListeners();
    }
  }
}
