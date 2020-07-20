import 'package:clients/model/order.dart';

class PickupOrderHistoryState {
  final List<PickupOrder> listOrder;
  final int page;
  final bool hasReachedMax;

  PickupOrderHistoryState({this.listOrder, this.page, this.hasReachedMax});
}

class LoadingPickupOrderHistoryState extends PickupOrderHistoryState {
  LoadingPickupOrderHistoryState({List<PickupOrder> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}

class ErrorPickupOrderHistoryState extends PickupOrderHistoryState {
  final String message;

  ErrorPickupOrderHistoryState(this.message, {List<PickupOrder> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}

class LoadingMorePickupOrderHistoryState extends PickupOrderHistoryState {
  LoadingMorePickupOrderHistoryState({List<PickupOrder> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}

class ErrorMorePickupOrderHistoryState extends PickupOrderHistoryState {
  final String message;

  ErrorMorePickupOrderHistoryState(this.message, {List<PickupOrder> listOrder, int page, bool hasReachedMax})
      : super(listOrder: listOrder, hasReachedMax: hasReachedMax, page: page);
}
