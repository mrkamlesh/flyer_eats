import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();
}

class GetOrderHistory extends OrderHistoryEvent {

  final String token;

  GetOrderHistory(this.token);

  @override
  List<Object> get props => [token];
}
