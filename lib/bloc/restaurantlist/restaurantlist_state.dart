import 'package:flyereats/model/filter.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/sort_by.dart';

class RestaurantListState {
  final List<Restaurant> restaurants;
  final int page;
  final List<SortBy> sortBy;
  final String selectedSortBy;
  final List<String> selectedFilter;
  final List<Filter> filters;
  final bool isLoading;
  final String error;
  final bool hasReachedMax;

  const RestaurantListState({
    this.selectedSortBy,
    this.selectedFilter,
    this.restaurants,
    this.page,
    this.filters,
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
        sortBy: List(),
        error: null,
        filters: List(),
        hasReachedMax: false,
        selectedSortBy: null,
        selectedFilter: List());
  }

/*  factory RestaurantListState.loading({
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
  }*/

  RestaurantListState copyWith(
      {List<Restaurant> restaurants,
      int page,
      List<SortBy> sortBy,
      String selectedSortBy,
      List<String> selectedFilter,
      List<Filter> filter,
      bool isLoading,
      String error,
      bool hasReachedMax}) {
    return RestaurantListState(
        restaurants: restaurants ?? this.restaurants,
        filters: filter ?? this.filters,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        selectedSortBy: selectedSortBy ?? this.selectedSortBy,
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading,
        sortBy: sortBy ?? this.sortBy);
  }
}
