import 'package:clients/model/order.dart';

class OrderHistoryState {
  final List<Order> listOrder;
  final int page;
  final bool hasReachedMax;

  OrderHistoryState({this.listOrder, this.page, this.hasReachedMax});
}

class LoadingOrderHistoryState extends OrderHistoryState {
  LoadingOrderHistoryState({List<Order> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, page: page, hasReachedMax: hasReachedMax);
}

class ErrorOrderHistoryState extends OrderHistoryState {
  final String message;

  ErrorOrderHistoryState(this.message, {List<Order> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, page: page, hasReachedMax: hasReachedMax);
}

class LoadingMoreOrderHistoryState extends OrderHistoryState {
  LoadingMoreOrderHistoryState({List<Order> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}

class ErrorMoreOrderHistoryState extends OrderHistoryState {
  final String message;

  ErrorMoreOrderHistoryState(this.message, {List<Order> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}
