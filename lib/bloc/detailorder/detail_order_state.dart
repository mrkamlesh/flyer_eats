import 'package:flyereats/model/detail_order.dart';

class DetailOrderState {
  DetailOrderState();
}

class LoadingDetailOrderState extends DetailOrderState {
  LoadingDetailOrderState();
}

class SuccessDetailOrderState extends DetailOrderState {
  final DetailOrder detailOrder;

  SuccessDetailOrderState(this.detailOrder);
}

class ErrorDetailOrderState extends DetailOrderState {
  final String message;
  ErrorDetailOrderState(this.message);
}
