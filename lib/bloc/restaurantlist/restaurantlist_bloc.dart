import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/restaurant.dart';
import './bloc.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  DataRepository repository = DataRepository();

  @override
  RestaurantListState get initialState => InitialRestaurantListState();

  @override
  Stream<RestaurantListState> mapEventToState(
    RestaurantListEvent event,
  ) async* {
    if (event is GetRestaurantList) {
      yield* mapGetRestaurantListToState(event.address);
    }
  }

  Stream<RestaurantListState> mapGetRestaurantListToState(
      String address) async* {
    yield LoadingRestaurantList();

    try {
      List<Restaurant> restaurants =
          await repository.getRestaurantList(address);
      if (restaurants.isEmpty) {
        yield NoRestaurantListAvaliable();
      } else {
        yield SuccessRestaurantList(restaurants);
      }
    } catch (e) {
      yield ErrorRestaurantList(e.toString());
    }
  }
}
