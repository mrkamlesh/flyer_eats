import 'package:clients/model/filter.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/sort_by.dart';

class RestaurantListState {
  final List<Restaurant> restaurants;
  final int page;
  final List<SortBy> sortBy;
  final String selectedSortBy;
  final List<String> selectedFilter;
  final List<Filter> filters;
  final bool isLoading;
  final String error;
  final bool isVeg;
  final bool hasReachedMax;

  const RestaurantListState(
      {this.selectedSortBy,
      this.selectedFilter,
      this.restaurants,
      this.page,
      this.filters,
      this.isLoading,
      this.error,
      this.sortBy,
      this.hasReachedMax,
      this.isVeg});

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
        isVeg: false,
        selectedFilter: List());
  }

  RestaurantListState copyWith(
      {List<Restaurant> restaurants,
      int page,
      List<SortBy> sortBy,
      String selectedSortBy,
      List<String> selectedFilter,
      List<Filter> filter,
      bool isLoading,
      String error,
      bool hasReachedMax,
      bool isVeg}) {
    return RestaurantListState(
        restaurants: restaurants ?? this.restaurants,
        filters: filter ?? this.filters,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        selectedSortBy: selectedSortBy ?? this.selectedSortBy,
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading,
        sortBy: sortBy ?? this.sortBy,
        isVeg: isVeg ?? this.isVeg);
  }
}
