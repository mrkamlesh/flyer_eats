class Review {
  final String username;
  final String avatar;
  final String review;
  final double rating;
  final String date;

  Review({this.username, this.avatar, this.review, this.rating, this.date});

  factory Review.fromJson(Map<String, dynamic> parsedJson) {
    return Review(
      username: parsedJson['client_name'],
      rating: double.parse(parsedJson['rating']),
      avatar: parsedJson['avatar'],
      date: parsedJson['date_created'],
      review: parsedJson['review'],
    );
  }
}
