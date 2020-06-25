import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailOrderEvent extends Equatable {
  const DetailOrderEvent();
}

class GetDetailOrder extends DetailOrderEvent {
  final String orderId;
  final String token;

  GetDetailOrder(this.orderId, this.token);

  @override
  List<Object> get props => [token];
}

class UpdateReviewRating extends DetailOrderEvent {
  final double rating;

  UpdateReviewRating(this.rating);

  @override
  List<Object> get props => [rating];
}

class UpdateReviewComment extends DetailOrderEvent {
  final String comment;

  UpdateReviewComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class AddReview extends DetailOrderEvent {
  final String token;

  AddReview(this.token);

  @override
  List<Object> get props => [token];
}
