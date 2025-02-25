import 'package:restauran_submission_1/data/model/review.dart';

class ReviewResponse {
  final bool error;
  final String message;
  final List<Review> customerReviews;

  ReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'customerReviews': customerReviews.map((x) => x.toJson()).toList(),
    };
  }

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      error: json["error"],
      message: json["message"] ?? "",
      customerReviews: json["customerReviews"] != null
          ? List<Review>.from(
              json["customerReviews"]!.map((x) => Review.fromJson(x)))
          : <Review>[],
    );
  }
}
