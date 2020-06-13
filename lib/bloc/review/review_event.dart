import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
}

class GetReview extends ReviewEvent {

  final String restaurantId;
  final String token;

  GetReview(this.restaurantId, this.token);

  @override
  List<Object> get props => [restaurantId, token];
}
