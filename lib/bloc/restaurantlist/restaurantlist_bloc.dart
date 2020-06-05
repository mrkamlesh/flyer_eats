import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/restaurantlist/restaurantlist_state.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/restaurant.dart';
import './bloc.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  DataRepository repository = DataRepository();

  @override
  RestaurantListState get initialState => RestaurantListState.initial();

  @override
  Stream<RestaurantListState> mapEventToState(
    RestaurantListEvent event,
  ) async* {
    if (event is GetFirstDataRestaurantList) {
      yield* mapGetRestaurantListToState(event.address);
    } else if (event is LoadMore) {
      yield* mapLoadMoreToState(event.address);
    }
  }

  Stream<RestaurantListState> mapGetRestaurantListToState(
      String address) async* {
    yield RestaurantListState.loading(restaurants: List(), page: 0);
    try {
      Map<String, dynamic> map =
          await repository.getFirstDataRestaurantList(address);

      yield RestaurantListState.firstLoaded(
          restaurants: map['restaurants'],
          page: state.page + 1,
          sortBy: map['sortBy'],
          filters: map['filters']);
    } catch (e) {
      yield RestaurantListState.error(
          restaurants: state.restaurants,
          filters: state.filter,
          sortBy: state.sortBy,
          page: state.page,
          error: e.toString());
    }
  }

  Stream<RestaurantListState> mapLoadMoreToState(String address) async* {
    yield RestaurantListState.loading(
        restaurants: state.restaurants,
        page: state.page,
        filters: state.filter,
        sortBy: state.sortBy);
    try {
      List<Restaurant> restaurants =
          await repository.getRestaurantList(address, state.page);

      restaurants = state.restaurants + restaurants;

      yield RestaurantListState.loaded(
          restaurants: restaurants,
          page: state.page + 1,
          filters: state.filter,
          sortBy: state.sortBy);
    } catch (e) {
      yield RestaurantListState.error(
          restaurants: state.restaurants,
          page: state.page,
          filters: state.filter,
          sortBy: state.sortBy,
          error: e.toString());
    }
  }
}
