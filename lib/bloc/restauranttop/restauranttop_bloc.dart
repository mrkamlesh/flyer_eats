import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/restaurant.dart';
import './bloc.dart';

class RestaurantTopBloc extends Bloc<RestaurantTopEvent, RestaurantTopState> {
  DataRepository repository = DataRepository();

  @override
  RestaurantTopState get initialState => InitialRestaurantTopState();

  @override
  Stream<RestaurantTopState> mapEventToState(
    RestaurantTopEvent event,
  ) async* {
    if (event is GetRestaurantTop) {
      yield* mapGetRestaurantTopToState(event.address);
    }
  }

  Stream<RestaurantTopState> mapGetRestaurantTopToState(String address) async* {
    yield LoadingRestaurantTop();

    try {
      List<Restaurant> restaurants =
          await repository.getRestaurantTop(address);
      if (restaurants.isEmpty) {
        yield NoRestaurantTopAvaliable();
      } else {
        yield SuccessRestaurantTop(restaurants);
      }
    } catch (e) {
      yield ErrorRestaurantTop(e.toString());
    }
  }
}
