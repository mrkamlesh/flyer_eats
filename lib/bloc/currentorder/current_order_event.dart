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
