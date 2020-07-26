import 'package:clients/model/restaurant.dart';

class SearchState {
  final List<Restaurant> restaurants;
  final int page;
  final String searchText;
  final bool hasReachedMax;

  SearchState({this.restaurants, this.page, this.searchText, this.hasReachedMax});
}

class InitialSearchState extends SearchState {
  InitialSearchState() : super();
}

class LoadingNewSearch extends SearchState {
  LoadingNewSearch() : super();
}

class ErrorNewSearch extends SearchState {
  final String message;

  ErrorNewSearch(this.message) : super();
}

class LoadingMore extends SearchState {
  LoadingMore({List<Restaurant> restaurants, int page, String searchText, bool hasReachedMax})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax);
}

class ErrorLoadingMore extends SearchState {
  final String message;

  ErrorLoadingMore(this.message,
      {List<Restaurant> restaurants, int page, String searchText, bool hasReachedMax})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax);
}

class CartState extends SearchState {
  CartState({List<Restaurant> restaurants, int page, String searchText, bool hasReachedMax})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax);
}
