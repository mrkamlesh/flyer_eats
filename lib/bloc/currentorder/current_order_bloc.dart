import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/status_order.dart';
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
    yield LoadingState(statusOrder: state.statusOrder);
    try {
      StatusOrder statusOrder = await repository.getActiveOrder(token);
      yield SuccessState(statusOrder: statusOrder);
    } catch (e) {
      yield ErrorState(e.toString(), statusOrder: state.statusOrder);
    }
  }
}
