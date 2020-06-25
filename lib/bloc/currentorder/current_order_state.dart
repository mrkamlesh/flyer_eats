import 'package:flyereats/model/status_order.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentOrderState {
  final StatusOrder statusOrder;

  CurrentOrderState({this.statusOrder});
}

class InitialCurrentOrderState extends CurrentOrderState {
  InitialCurrentOrderState() : super();
}

class LoadingState extends CurrentOrderState {
  LoadingState({StatusOrder statusOrder}) : super(statusOrder: statusOrder);
}

class SuccessState extends CurrentOrderState {
  SuccessState({StatusOrder statusOrder}) : super(statusOrder: statusOrder);
}

class ErrorState extends CurrentOrderState {
  final String message;

  ErrorState(this.message, {StatusOrder statusOrder})
      : super(statusOrder: statusOrder);
}
