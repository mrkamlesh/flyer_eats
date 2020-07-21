import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/detail_order.dart';
import './bloc.dart';

class PickupDetailOrderBloc extends Bloc<PickupDetailOrderEvent, PickupDetailOrderState> {
  DataRepository repository = DataRepository();

  @override
  PickupDetailOrderState get initialState => LoadingPickupDetailOrderState();

  @override
  Stream<PickupDetailOrderState> mapEventToState(
    PickupDetailOrderEvent event,
  ) async* {
    if (event is GetDetailPickupOrder) {
      yield* mapGetDetailPickupOrderToState(event.token, event.orderId);
    }
  }

  Stream<PickupDetailOrderState> mapGetDetailPickupOrderToState(String token, String orderId) async* {
    try {
      var result = await repository.getPickupDetailOrder(token, orderId);
      if (result is PickupDetailOrder) {
        yield PickupDetailOrderState(detailOrder: result);
      } else {
        yield ErrorPickupDetailOrderState(result as String);
      }
    } catch (e) {
      yield ErrorPickupDetailOrderState(e.toString());
    }
  }
}
