import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PickupOrderHistoryEvent extends Equatable {
  const PickupOrderHistoryEvent();
}

class GetPickupOrderHistory extends PickupOrderHistoryEvent {
  final String token;

  GetPickupOrderHistory(this.token);

  @override
  List<Object> get props => [token];
}

class OnLoadMorePickup extends PickupOrderHistoryEvent {
  final String token;

  OnLoadMorePickup(this.token);

  @override
  List<Object> get props => [token];
}
