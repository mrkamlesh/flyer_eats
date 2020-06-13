import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/detail_order.dart';
import './bloc.dart';

class DetailOrderBloc extends Bloc<DetailOrderEvent, DetailOrderState> {
  DataRepository repository = DataRepository();

  @override
  DetailOrderState get initialState => LoadingDetailOrderState();

  @override
  Stream<DetailOrderState> mapEventToState(
    DetailOrderEvent event,
  ) async* {
    if (event is GetDetailOrder) {
      yield* mapGetDetailOrderToState(event.orderId, event.token);
    }
  }

  Stream<DetailOrderState> mapGetDetailOrderToState(
      String orderId, String token) async* {
    yield LoadingDetailOrderState();
    try {
      DetailOrder orderDetail = await repository.getDetailOrder(orderId, token);
      yield SuccessDetailOrderState(orderDetail);
    } catch (e) {
      yield ErrorDetailOrderState(e.toString());
    }
  }
}
