import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PickupDetailOrderEvent extends Equatable {
  const PickupDetailOrderEvent();
}

class GetDetailPickupOrder extends PickupDetailOrderEvent {
  final String orderId;
  final String token;

  GetDetailPickupOrder(this.orderId, this.token);

  @override
  List<Object> get props => [token];
}