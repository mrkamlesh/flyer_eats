import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/restaurant.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_restaurant_event.dart';

part 'search_restaurant_state.dart';

class SearchRestaurantBloc
    extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {
  DataRepository repository = DataRepository();

  @override
  SearchRestaurantState get initialState => InitialSearchRestaurantState();

  @override
  Stream<SearchRestaurantState> mapEventToState(
    SearchRestaurantEvent event,
  ) async* {
    if (event is SearchRestaurant) {
      yield* mapSearchRestaurant(event.token, event.address, event.searchText);
    }
  }

  Stream<SearchRestaurantState> mapSearchRestaurant(
      String token, String address, String searchText) async* {
    if (searchText != "" && searchText != null) {
      yield LoadingNewSearchRestaurant();
      try {
        List<Restaurant> list =
            await repository.searchRestaurant(token, address, searchText);
        if (list.isNotEmpty) {
          yield SearchRestaurantState(restaurants: list);
        } else {
          yield NoAvailableSearchRestaurant();
        }
      } catch (e) {
        yield ErrorNewSearchRestaurant(e.toString());
      }
    } else {
      yield InitialSearchRestaurantState();
    }
  }
}
