class Review {
  final String name;
  final String review;
  final String date;

  Review({
    required this.name,
    required this.review,
    required this.date,
  });

  Review copyWith({
    String? name,
    String? review,
    String? date,
  }) {
    return Review(
      name: name ?? this.name,
      review: review ?? this.review,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'review': review,
      'date': date,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] as String,
      review: json['review'] as String,
      date: json['date'] as String,
    );
  }

  @override
  String toString() => 'Review(name: $name, review: $review, date: $date)';

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.name == name && other.review == review && other.date == date;
  }

  @override
  int get hashCode => name.hashCode ^ review.hashCode ^ date.hashCode;
}
