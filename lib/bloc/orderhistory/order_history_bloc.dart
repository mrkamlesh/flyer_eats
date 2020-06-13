import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/order.dart';
import './bloc.dart';

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
    }
  }

  Stream<OrderHistoryState> mapGetOrderHistoryToState(String token) async* {
    try {
      List<Order> list = await repository.getOrderHistory(token);
      yield SuccessOrderHistoryState(list);
    } catch (e) {
      yield ErrorOrderHistoryState(e.toString());
    }
  }
}
