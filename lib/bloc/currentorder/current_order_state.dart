import 'package:flyereats/model/current_order.dart';
import 'package:meta/meta.dart';

@immutable
class CurrentOrderState {
  final CurrentOrder currentOrder;
  final String comment;
  final double rating;
  final bool hasGivenStar;

  CurrentOrderState({this.comment, this.rating, this.hasGivenStar, this.currentOrder});

  bool isReviewValid() {
    return hasGivenStar && comment != null && comment != "";
  }
}

class InitialCurrentOrderState extends CurrentOrderState {
  InitialCurrentOrderState() : super(currentOrder: CurrentOrder(isActive: false));
}

class LoadingState extends CurrentOrderState {
  LoadingState({CurrentOrder currentOrder}) : super(currentOrder: currentOrder);
}

class SuccessState extends CurrentOrderState {
  SuccessState({CurrentOrder currentOrder}) : super(currentOrder: currentOrder);
}

class NoActiveOrderState extends CurrentOrderState {
  NoActiveOrderState({CurrentOrder currentOrder}) : super(currentOrder: currentOrder);
}

class DeliveredOrderState extends CurrentOrderState {
  DeliveredOrderState({CurrentOrder currentOrder}) : super(currentOrder: currentOrder, rating: 0, hasGivenStar: false);
}

class CancelledOrderState extends CurrentOrderState {
  CancelledOrderState({CurrentOrder currentOrder}) : super(currentOrder: currentOrder);
}

class ErrorState extends CurrentOrderState {
  final String message;

  ErrorState(this.message, {CurrentOrder currentOrder}) : super(currentOrder: currentOrder);
}

class LoadingAddReview extends CurrentOrderState {
  LoadingAddReview({CurrentOrder currentOrder, String comment, double rating, bool hasGivenStar})
      : super(currentOrder: currentOrder, comment: comment, rating: rating, hasGivenStar: hasGivenStar);
}

class SuccessAddReview extends CurrentOrderState {
  SuccessAddReview({CurrentOrder currentOrder, String comment, double rating, bool hasGivenStar})
      : super(currentOrder: currentOrder, comment: comment, rating: rating, hasGivenStar: hasGivenStar);
}

class ErrorAddReview extends CurrentOrderState {
  final String message;

  ErrorAddReview(this.message, {CurrentOrder currentOrder, String comment, double rating, bool hasGivenStar})
      : super(currentOrder: currentOrder, comment: comment, rating: rating, hasGivenStar: hasGivenStar);
}

class CardScratched extends CurrentOrderState {

  CardScratched({CurrentOrder currentOrder, String comment, double rating, bool hasGivenStar})
      : super(currentOrder: currentOrder, comment: comment, rating: rating, hasGivenStar: hasGivenStar);
}
