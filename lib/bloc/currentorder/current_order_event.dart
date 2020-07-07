import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentOrderEvent extends Equatable {
  const CurrentOrderEvent();
}

class GetActiveOrder extends CurrentOrderEvent {
  final String token;

  GetActiveOrder(this.token);

  @override
  List<Object> get props => [token];
}

class Retry extends CurrentOrderEvent {
  final String token;

  Retry(this.token);

  @override
  List<Object> get props => [token];
}

class AddReview extends CurrentOrderEvent {
  final String token;
  final String orderId;

  AddReview(this.token, this.orderId);

  @override
  List<Object> get props => [token, orderId];
}

class UpdateReviewRating extends CurrentOrderEvent {
  final double rating;

  UpdateReviewRating(this.rating);

  @override
  List<Object> get props => [rating];
}

class UpdateReviewComment extends CurrentOrderEvent {
  final String comment;

  UpdateReviewComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class ScratchCardEvent extends CurrentOrderEvent {
  final String token;
  final String cardId;

  ScratchCardEvent(this.token, this.cardId);

  @override
  List<Object> get props => [token, cardId];
}
