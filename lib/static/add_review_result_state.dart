import 'package:restauran_submission_1/data/model/review.dart';

sealed class AddReviewResultState {}

class AddReviewNoneState extends AddReviewResultState {}

class AddReviewLoadingState extends AddReviewResultState {}

class AddReviewErrorState extends AddReviewResultState {
  final String error;

  AddReviewErrorState(this.error);
}

class AddReviewLoadedState extends AddReviewResultState {
  final List<Review> data;

  AddReviewLoadedState(this.data);
}
