import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';

class SearchState {
  final List<Restaurant> restaurants;
  final int page;
  final String searchText;
  final bool hasReachedMax;
  final FoodCart foodCart;
  final Restaurant selectedRestaurant;

  SearchState(
      {this.restaurants, this.page, this.searchText, this.hasReachedMax, this.foodCart, this.selectedRestaurant});
}

class InitialSearchState extends SearchState {
  InitialSearchState({FoodCart foodCart, Restaurant selectedRestaurant})
      : super(foodCart: foodCart, selectedRestaurant: selectedRestaurant);
}

class LoadingNewSearch extends SearchState {
  LoadingNewSearch({FoodCart foodCart, Restaurant selectedRestaurant})
      : super(foodCart: foodCart, selectedRestaurant: selectedRestaurant);
}

class ErrorNewSearch extends SearchState {
  final String message;

  ErrorNewSearch(this.message, {FoodCart foodCart, Restaurant selectedRestaurant})
      : super(foodCart: foodCart, selectedRestaurant: selectedRestaurant);
}

class LoadingMore extends SearchState {
  LoadingMore(
      {List<Restaurant> restaurants,
      int page,
      String searchText,
      bool hasReachedMax,
      FoodCart foodCart,
      Restaurant selectedRestaurant})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax,
            foodCart: foodCart,
            selectedRestaurant: selectedRestaurant);
}

class ErrorLoadingMore extends SearchState {
  final String message;

  ErrorLoadingMore(this.message,
      {List<Restaurant> restaurants,
      int page,
      String searchText,
      bool hasReachedMax,
      FoodCart foodCart,
      Restaurant selectedRestaurant})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax,
            foodCart: foodCart,
            selectedRestaurant: selectedRestaurant);
}

class CartState extends SearchState {
  CartState(
      {List<Restaurant> restaurants,
      int page,
      String searchText,
      bool hasReachedMax,
      FoodCart foodCart,
      Restaurant selectedRestaurant})
      : super(
            restaurants: restaurants,
            page: page,
            searchText: searchText,
            hasReachedMax: hasReachedMax,
            foodCart: foodCart,
            selectedRestaurant: selectedRestaurant);
}
