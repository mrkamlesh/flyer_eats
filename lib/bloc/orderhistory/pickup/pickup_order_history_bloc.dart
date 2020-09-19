import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/order.dart';
import './bloc.dart';

class PickupOrderHistoryBloc
    extends Bloc<PickupOrderHistoryEvent, PickupOrderHistoryState> {
  DataRepository repository = DataRepository();

  @override
  PickupOrderHistoryState get initialState => LoadingPickupOrderHistoryState();

  @override
  Stream<PickupOrderHistoryState> mapEventToState(
    PickupOrderHistoryEvent event,
  ) async* {
    if (event is GetPickupOrderHistory) {
      yield* mapGetOrderHistoryToState(event.token);
    } else if (event is OnLoadMorePickup) {
      yield* mapOnLoadMoreToState(event.token);
    }
  }

  Stream<PickupOrderHistoryState> mapGetOrderHistoryToState(
      String token) async* {
    if (state.listOrder == null) {
      yield LoadingPickupOrderHistoryState();
      try {
        List<PickupOrder> list =
            await repository.getPickupOrderHistory(token, "pickup_drop", 0);

        yield PickupOrderHistoryState(
            page: 1, listOrder: list, hasReachedMax: list.isEmpty);
      } catch (e) {
        yield ErrorPickupOrderHistoryState(e.toString());
      }
    }
  }

  Stream<PickupOrderHistoryState> mapOnLoadMoreToState(String token) async* {
    if (!state.hasReachedMax) {
      yield LoadingMorePickupOrderHistoryState(
          page: state.page,
          hasReachedMax: state.hasReachedMax,
          listOrder: state.listOrder);

      try {
        List<PickupOrder> list = await repository.getPickupOrderHistory(
            token, "pickup_drop", state.page);
        yield PickupOrderHistoryState(
          page: state.page + 1,
          hasReachedMax: list.isEmpty,
          listOrder: state.listOrder + list,
        );
      } catch (e) {
        yield ErrorMorePickupOrderHistoryState(e.toString(),
            page: state.page,
            hasReachedMax: state.hasReachedMax,
            listOrder: state.listOrder);
      }
    }
  }
}
