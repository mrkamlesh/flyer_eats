import 'package:clients/model/detail_order.dart';

class PickupDetailOrderState {
  final PickupDetailOrder detailOrder;

  PickupDetailOrderState({this.detailOrder});
}

class LoadingPickupDetailOrderState extends PickupDetailOrderState {}

class ErrorPickupDetailOrderState extends PickupDetailOrderState {
  final String message;

  ErrorPickupDetailOrderState(this.message);
}
