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
