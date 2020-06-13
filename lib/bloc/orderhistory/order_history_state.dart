import 'package:flyereats/model/order.dart';

class OrderHistoryState {
  OrderHistoryState();
}

class LoadingOrderHistoryState extends OrderHistoryState {
  LoadingOrderHistoryState();
}

class SuccessOrderHistoryState extends OrderHistoryState {
  final List<Order> listOrder;

  SuccessOrderHistoryState(this.listOrder);
}

class ErrorOrderHistoryState extends OrderHistoryState {
  final String message;
  ErrorOrderHistoryState(this.message);
}
