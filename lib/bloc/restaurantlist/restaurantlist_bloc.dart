import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/restaurantlist/restaurantlist_state.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
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
      yield* mapGetFirstDataRestaurantListToState(event.token, event.address,
          event.merchantType, event.type, event.category);
    } else if (event is LoadMore) {
      yield* mapLoadMoreToState(event.token, event.address, event.merchantType,
          event.type, event.category);
    } else if (event is SelectSortBy) {
      yield* mapSelectSortByToState(event.selectedSortBy);
    } else if (event is AddFilter) {
      yield* mapAddFilterToState(event.addedFilter);
    } else if (event is RemoveFilter) {
      yield* mapRemoveFilterToState(event.removedFilter);
    } else if (event is ApplyFilter) {
      yield* mapApplyFilterToState(event.token, event.address,
          event.merchantType, event.type, event.category);
    } else if (event is ClearFilter) {
      yield* mapGetFirstDataRestaurantListToState(event.token, event.address,
          event.merchantType, event.type, event.category);
    }
  }

  Stream<RestaurantListState> mapGetFirstDataRestaurantListToState(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category) async* {
    yield state.copyWith(
        isLoading: true,
        restaurants: List(),
        selectedFilter: List(),
        selectedSortBy: null);
    try {
      Map<String, dynamic> map = await repository.getFirstDataRestaurantList(
          token, address, merchantType, type, category);

      yield state.copyWith(
          restaurants: map['restaurants'],
          page: state.page + 1,
          sortBy: map['sortBy'],
          filter: map['filters'],
          isLoading: false);
    } catch (e) {
      yield state.copyWith(error: e.toString());
    }
  }

  Stream<RestaurantListState> mapLoadMoreToState(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category) async* {
    yield state.copyWith(isLoading: true, error: null);
    try {
      List<Restaurant> restaurants = await repository.getRestaurantList(
          token, address, merchantType, type, category, state.page);

      restaurants = state.restaurants + restaurants;

      yield state.copyWith(
          restaurants: restaurants, page: state.page + 1, isLoading: false);
    } catch (e) {
      yield state.copyWith(error: e.toString());
    }
  }

  Stream<RestaurantListState> mapSelectSortByToState(
      String selectedSortBy) async* {
    yield state.copyWith(selectedSortBy: selectedSortBy);
  }

  Stream<RestaurantListState> mapAddFilterToState(String addedFilter) async* {
    List<String> selectedFilters = state.selectedFilter;
    selectedFilters.add(addedFilter);
    yield state.copyWith(selectedFilter: selectedFilters);
  }

  Stream<RestaurantListState> mapRemoveFilterToState(
      String removedFilter) async* {
    List<String> selectedFilters = state.selectedFilter;
    selectedFilters.remove(removedFilter);
    yield state.copyWith(selectedFilter: selectedFilters);
  }

  Stream<RestaurantListState> mapApplyFilterToState(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category) async* {
    String selectedSortBy = state.selectedSortBy;
    String selectedFilters = state.selectedFilter.join(",");

    yield state.copyWith(isLoading: true, restaurants: List());
    try {
      Map<String, dynamic> map = await repository.getFirstDataRestaurantList(
          token, address, merchantType, type, category,
          cuisineType: selectedFilters, sortBy: selectedSortBy);

      yield state.copyWith(
          restaurants: map['restaurants'],
          page: state.page + 1,
          sortBy: map['sortBy'],
          filter: map['filters'],
          isLoading: false);
    } catch (e) {
      yield state.copyWith(error: e.toString());
    }
  }
}
