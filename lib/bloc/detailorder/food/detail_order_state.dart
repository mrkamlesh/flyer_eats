import 'package:clients/model/detail_order.dart';

class DetailOrderState {
  final double rating;
  final String comment;
  final bool isReviewAdded;
  final bool hasGivenStar;
  final DetailOrder detailOrder;

  DetailOrderState(
      {this.isReviewAdded,
      this.rating,
      this.comment,
      this.hasGivenStar,
      this.detailOrder});

  bool isReviewValid() {
    return hasGivenStar && comment != null && comment != "";
  }

  DetailOrderState copyWith({
    bool isReviewAdded,
    double rating,
    String comment,
    bool hasGivenStar,
    DetailOrder detailOrder,
  }) {
    return DetailOrderState(
        isReviewAdded: isReviewAdded ?? this.isReviewAdded,
        comment: comment ?? this.comment,
        detailOrder: detailOrder ?? this.detailOrder,
        hasGivenStar: hasGivenStar ?? this.hasGivenStar,
        rating: rating ?? this.rating);
  }
}

class LoadingDetailOrderState extends DetailOrderState {
  LoadingDetailOrderState()
      : super(
            isReviewAdded: false,
            hasGivenStar: false,
            rating: 0,
            comment: null,
            detailOrder: null);
}

class ErrorDetailOrderState extends DetailOrderState {
  final String message;

  ErrorDetailOrderState(
    this.message, {
    bool isReviewAdded,
    double rating,
    String comment,
    bool hasGivenStar,
    DetailOrder detailOrder,
  }) : super(
            isReviewAdded: isReviewAdded,
            rating: rating,
            hasGivenStar: hasGivenStar,
            comment: comment,
            detailOrder: detailOrder);
}

class LoadingAddReview extends DetailOrderState {
  LoadingAddReview({
    bool isReviewAdded,
    double rating,
    String comment,
    bool hasGivenStar,
    DetailOrder detailOrder,
  }) : super(
            isReviewAdded: isReviewAdded,
            rating: rating,
            hasGivenStar: hasGivenStar,
            comment: comment,
            detailOrder: detailOrder);
}

class SuccessAddReview extends DetailOrderState {
  SuccessAddReview({
    bool isReviewAdded,
    double rating,
    String comment,
    bool hasGivenStar,
    DetailOrder detailOrder,
  }) : super(
            isReviewAdded: isReviewAdded,
            rating: rating,
            hasGivenStar: hasGivenStar,
            comment: comment,
            detailOrder: detailOrder);
}

class ErrorAddReview extends DetailOrderState {
  final String message;

  ErrorAddReview(
    this.message, {
    bool isReviewAdded,
    double rating,
    String comment,
    bool hasGivenStar,
    DetailOrder detailOrder,
  }) : super(
            isReviewAdded: isReviewAdded,
            rating: rating,
            hasGivenStar: hasGivenStar,
            comment: comment,
            detailOrder: detailOrder);
}
