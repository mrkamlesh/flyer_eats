part of 'search_restaurant_bloc.dart';

class SearchRestaurantState {
  final List<Restaurant> restaurants;

  SearchRestaurantState({this.restaurants});
}

class InitialSearchRestaurantState extends SearchRestaurantState {
  InitialSearchRestaurantState() : super();
}

class LoadingNewSearchRestaurant extends SearchRestaurantState {
  LoadingNewSearchRestaurant() : super();
}

class NoAvailableSearchRestaurant extends SearchRestaurantState {
  NoAvailableSearchRestaurant() : super();
}

class ErrorNewSearchRestaurant extends SearchRestaurantState {
  final String message;

  ErrorNewSearchRestaurant(this.message) : super();
}
