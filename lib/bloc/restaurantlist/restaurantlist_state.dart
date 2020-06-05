import 'package:flyereats/model/filter.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/sort_by.dart';

class RestaurantListState {
  final List<Restaurant> restaurants;
  final int page;
  final List<SortBy> sortBy;
  final List<Filter> filter;
  final bool isLoading;
  final String error;
  final bool hasReachedMax;

  const RestaurantListState({
    this.restaurants,
    this.page,
    this.filter,
    this.isLoading,
    this.error,
    this.sortBy,
    this.hasReachedMax,
  });

  factory RestaurantListState.initial() {
    return RestaurantListState(
        restaurants: List(),
        page: 0,
        isLoading: true,
        sortBy: null,
        error: null,
        hasReachedMax: false);
  }

  factory RestaurantListState.loading({
    List<Restaurant> restaurants,
    int page,
    List<SortBy> sortBy,
    List<Filter> filters,
  }) {
    return RestaurantListState(
      restaurants: restaurants,
      filter: filters,
      sortBy: sortBy,
      page: page,
      isLoading: true,
      error: null,
      hasReachedMax: false,
    );
  }

  factory RestaurantListState.firstLoaded(
      {List<Restaurant> restaurants,
      List<SortBy> sortBy,
      List<Filter> filters,
      int page,
      bool hasReachedMax}) {
    return RestaurantListState(
      restaurants: restaurants,
      filter: filters,
      sortBy: sortBy,
      page: page,
      isLoading: false,
      error: null,
    );
  }

  factory RestaurantListState.loaded(
      {List<Restaurant> restaurants,
      List<SortBy> sortBy,
      List<Filter> filters,
      int page,
      bool hasReachedMax}) {
    return RestaurantListState(
        restaurants: restaurants,
        filter: filters,
        sortBy: sortBy,
        page: page,
        isLoading: false,
        error: null,
        hasReachedMax: hasReachedMax);
  }

  factory RestaurantListState.error(
      {List<Restaurant> restaurants,
      List<SortBy> sortBy,
      List<Filter> filters,
      int page,
      String error}) {
    return RestaurantListState(
        restaurants: restaurants,
        filter: filters,
        sortBy: sortBy,
        page: page,
        isLoading: false,
        error: error);
  }

  RestaurantListState copyWith(
      {List<Restaurant> list,
      int page,
      String sortBy,
      List<String> cuisineType,
      bool isLoading,
      bool hasReachedMax}) {
    return RestaurantListState(
        restaurants: restaurants ?? this.restaurants,
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading,
        sortBy: sortBy ?? this.sortBy);
  }
}
