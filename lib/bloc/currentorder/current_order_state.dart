import 'package:flyereats/model/status_order.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentOrderState {
  final StatusOrder statusOrder;
  final String orderId;
  final bool isActive;

  CurrentOrderState({this.orderId, this.statusOrder, this.isActive});
}

class InitialCurrentOrderState extends CurrentOrderState {
  InitialCurrentOrderState()
      : super(isActive: false);
}

class LoadingState extends CurrentOrderState {
  LoadingState({StatusOrder statusOrder, String orderId, bool isActive})
      : super(statusOrder: statusOrder, orderId: orderId, isActive: isActive);
}

class SuccessState extends CurrentOrderState {
  SuccessState({StatusOrder statusOrder, String orderId, bool isActive})
      : super(statusOrder: statusOrder, orderId: orderId, isActive: isActive);
}

class NoActiveOrderState extends CurrentOrderState {
  NoActiveOrderState({StatusOrder statusOrder, String orderId, bool isActive})
      : super(statusOrder: statusOrder, orderId: orderId, isActive: isActive);
}

class ErrorState extends CurrentOrderState {
  final String message;

  ErrorState(this.message,
      {StatusOrder statusOrder, String orderId, bool isActive})
      : super(statusOrder: statusOrder, orderId: orderId, isActive: isActive);
}
