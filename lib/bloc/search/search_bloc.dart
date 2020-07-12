import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/search/search_event.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  DataRepository repository = DataRepository();

  @override
  SearchState get initialState => InitialSearchState(foodCart: FoodCart(Map()));

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is Search) {
      yield* mapSearchToState(event.token, event.address, event.searchText);
    } else if (event is LoadMore) {
      yield* mapLoadMoreToState(event.token, event.address);
    } else if (event is ChangeQuantity) {
      yield* mapChangeQuantityToState(event.id, event.food, event.quantity, event.selectedRestaurant, event.selectedPrice);
    } else if (event is ClearCart) {
      yield* mapClearCartToState();
    } else if (event is UpdateCart) {
      yield* mapUpdateCartToState(event.foodCart);
    }
  }

  Stream<SearchState> mapSearchToState(String token, String address, String searchText) async* {
    if (searchText != "" && searchText != null) {
      yield LoadingNewSearch(foodCart: state.foodCart, selectedRestaurant: state.selectedRestaurant);
      try {
        List<Restaurant> list = await repository.globalSearch(token, searchText, address, 0);

        yield SearchState(
            page: 1,
            restaurants: list,
            hasReachedMax: list.isEmpty,
            searchText: searchText,
            foodCart: state.foodCart,
            selectedRestaurant: state.selectedRestaurant);
      } catch (e) {
        yield ErrorNewSearch(e.toString(), foodCart: state.foodCart, selectedRestaurant: state.selectedRestaurant);
      }
    } else {
      yield InitialSearchState(foodCart: state.foodCart, selectedRestaurant: state.selectedRestaurant);
    }
  }

  Stream<SearchState> mapLoadMoreToState(String token, String address) async* {
    yield LoadingMore(
        page: state.page,
        hasReachedMax: state.hasReachedMax,
        searchText: state.searchText,
        restaurants: state.restaurants,
        foodCart: state.foodCart,
        selectedRestaurant: state.selectedRestaurant);

    try {
      List<Restaurant> list = await repository.globalSearch(token, state.searchText, address, state.page);
      yield SearchState(
          page: state.page + 1,
          hasReachedMax: list.isEmpty,
          searchText: state.searchText,
          restaurants: state.restaurants + list,
          foodCart: state.foodCart,
          selectedRestaurant: state.selectedRestaurant);
    } catch (e) {
      yield ErrorLoadingMore(e.toString(),
          page: state.page,
          hasReachedMax: state.hasReachedMax,
          searchText: state.searchText,
          restaurants: state.restaurants,
          foodCart: state.foodCart,
          selectedRestaurant: state.selectedRestaurant);
    }
  }

  Stream<SearchState> mapChangeQuantityToState(
      String id, Food food, int quantity, Restaurant selectedRestaurant, int selectedPrice) async* {
    //yield OnDataLoading();
    FoodCart cart = FoodCart(Map.from((state.foodCart).cart));
    cart.changeQuantity(id, food, quantity, selectedPrice);

    yield CartState(
        foodCart: cart,
        searchText: state.searchText,
        hasReachedMax: state.hasReachedMax,
        page: state.page,
        restaurants: state.restaurants,
        selectedRestaurant: selectedRestaurant);
  }

  Stream<SearchState> mapClearCartToState() async* {
    yield SearchState(
        page: state.page,
        hasReachedMax: state.hasReachedMax,
        searchText: state.searchText,
        restaurants: state.restaurants,
        foodCart: FoodCart(Map()),
        selectedRestaurant: state.selectedRestaurant);
  }

  Stream<SearchState> mapUpdateCartToState(FoodCart foodCart) async* {
    yield SearchState(
        page: state.page,
        hasReachedMax: state.hasReachedMax,
        searchText: state.searchText,
        restaurants: state.restaurants,
        foodCart: foodCart,
        selectedRestaurant: state.selectedRestaurant);
  }
}
