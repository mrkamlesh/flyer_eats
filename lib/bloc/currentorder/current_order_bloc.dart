import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import './bloc.dart';

class CurrentOrderBloc extends Bloc<CurrentOrderEvent, CurrentOrderState> {
  DataRepository repository = DataRepository();

  @override
  CurrentOrderState get initialState => InitialCurrentOrderState();

  @override
  Stream<CurrentOrderState> mapEventToState(
    CurrentOrderEvent event,
  ) async* {
    if (event is GetActiveOrder) {
      yield* mapGetActiveOrderToState(event.token);
    }
  }

  Stream<CurrentOrderState> mapGetActiveOrderToState(String token) async* {
    yield LoadingState(statusOrder: state.statusOrder, isActive: state.isActive, orderId: state.orderId);
    try {
      Map<String, dynamic> map = await repository.getActiveOrder(token);
      if (map.containsKey("order_id")) {
        yield SuccessState(orderId: map['order_id'], isActive: map['active_order'], statusOrder: map['status_order']);
        Future.delayed(Duration(seconds: 3), () {
          add(GetActiveOrder(token));
        });
      } else {
        yield NoActiveOrderState();
      }
    } catch (e) {
      yield ErrorState(e.toString(), statusOrder: state.statusOrder, isActive: state.isActive, orderId: state.orderId);
      Future.delayed(Duration(seconds: 3), () {
        add(GetActiveOrder(token));
      });
    }
  }
}
