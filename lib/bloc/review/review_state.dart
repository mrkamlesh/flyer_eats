import 'package:flyereats/model/review.dart';

class ReviewState {
  ReviewState();
}

class LoadingReviewState extends ReviewState {
  LoadingReviewState();
}

class SuccessReviewState extends ReviewState {
  final List<Review> listReview;

  SuccessReviewState(this.listReview);
}

class ErrorReviewState extends ReviewState {
  final String message;

  ErrorReviewState(this.message);
}
