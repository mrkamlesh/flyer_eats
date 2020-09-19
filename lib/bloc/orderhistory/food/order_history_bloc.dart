import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/order.dart';
import 'bloc.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  DataRepository repository = DataRepository();

  @override
  OrderHistoryState get initialState => LoadingOrderHistoryState();

  @override
  Stream<OrderHistoryState> mapEventToState(
    OrderHistoryEvent event,
  ) async* {
    if (event is GetOrderHistory) {
      yield* mapGetOrderHistoryToState(event.token);
    } else if (event is OnLoadMore) {
      yield* mapOnLoadMoreToState(event.token);
    }
  }

  Stream<OrderHistoryState> mapGetOrderHistoryToState(String token) async* {
    if (state.listOrder == null) {
      yield LoadingOrderHistoryState();
      try {
        List<Order> list =
            await repository.getOrderHistory(token, "delivery", 0);

        yield OrderHistoryState(
            page: 1, listOrder: list, hasReachedMax: list.isEmpty);
      } catch (e) {
        yield ErrorOrderHistoryState(e.toString());
      }
    }
  }

  Stream<OrderHistoryState> mapOnLoadMoreToState(String token) async* {
    if (!state.hasReachedMax) {
      yield LoadingMoreOrderHistoryState(
          page: state.page,
          hasReachedMax: state.hasReachedMax,
          listOrder: state.listOrder);

      try {
        List<Order> list =
            await repository.getOrderHistory(token, "delivery", state.page);
        yield OrderHistoryState(
          page: state.page + 1,
          hasReachedMax: list.isEmpty,
          listOrder: state.listOrder + list,
        );
      } catch (e) {
        yield ErrorMoreOrderHistoryState(e.toString(),
            page: state.page,
            hasReachedMax: state.hasReachedMax,
            listOrder: state.listOrder);
      }
    }
  }
}
