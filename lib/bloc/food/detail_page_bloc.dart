import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/menu_category.dart';
import 'bloc.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {
  DataRepository repository = DataRepository();

  DetailPageBloc();

  @override
  DetailPageState get initialState => Initialize();

  @override
  Stream<DetailPageState> mapEventToState(
    DetailPageEvent event,
  ) async* {
    if (event is PageDetailRestaurantOpen) {
      yield* mapPageOpenToState(event.restaurantId);
    } else if (event is SwitchVegOnly) {
      yield* mapSwitchVegOnlyToState(event.restaurantId, event.isVegOnly);
    } else if (event is ChangeQuantity) {
      yield* mapChangeQuantityToState(event.id, event.food, event.quantity, event.selectedPrice);
    } else if (event is RestaurantMenuChange) {
      yield* mapRestaurantMenuChangeToState(event.restaurantId, event.menuId, event.menuSelected);
    } else if (event is UpdateCart) {
      yield* mapUpdateCartToState(event.foodCart);
    } else if (event is SearchFood) {
      yield* mapSearchFoodToState(event.restaurantId, event.keyword);
    }
  }

  Stream<DetailPageState> mapPageOpenToState(String restaurantId) async* {
    yield OnDataLoading(
        foodCart: state.foodCart,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
    try {
      List<MenuCategory> menus = await repository.getCategories(restaurantId);
      List<Food> foods = await repository.getFoods(restaurantId, menus[state.menuSelected].id, false, null);

      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: menus,
            foodCart: state.foodCart,
            isVegOnly: state.isVegOnly,
            foodList: List(),
            menuSelected: state.menuSelected);
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly,
            foodCart: state.foodCart,
            menuCategories: menus,
            foodList: foods,
            menuSelected: state.menuSelected);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(String restaurantId, bool isVegOnly) async* {
    yield OnDataLoading(
        foodCart: state.foodCart,
        isVegOnly: isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
    try {
      List<Food> foods =
          await repository.getFoods(restaurantId, state.menuCategories[state.menuSelected].id, isVegOnly, null);

      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: state.menuCategories,
            foodCart: state.foodCart,
            isVegOnly: isVegOnly,
            foodList: List(),
            menuSelected: state.menuSelected);
      } else {
        yield DetailPageState(
            isVegOnly: isVegOnly,
            foodCart: state.foodCart,
            menuCategories: state.menuCategories,
            foodList: foods,
            menuSelected: state.menuSelected);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
    }
  }

  Stream<DetailPageState> mapSwitchCategoryToState(String id) async* {}

  Stream<DetailPageState> mapChangeQuantityToState(String id, Food food, int quantity, int selectedPrice) async* {
    //yield OnDataLoading();
    FoodCart cart = FoodCart(Map.from((state.foodCart).cart));
    cart.changeQuantity(id, food, quantity, selectedPrice);

    yield CartState(
        isVegOnly: state.isVegOnly,
        foodCart: cart,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected,
        result: state.result);
  }

  Stream<DetailPageState> mapRestaurantMenuChangeToState(String restaurantId, String menuId, int menuSelected) async* {
    yield OnDataLoading(
        foodCart: state.foodCart,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: List(),
        menuSelected: menuSelected);
    try {
      List<Food> foods = await repository.getFoods(restaurantId, menuId, state.isVegOnly, null);
      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: state.menuCategories,
            foodCart: state.foodCart,
            isVegOnly: state.isVegOnly,
            foodList: List(),
            menuSelected: menuSelected);
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly,
            foodCart: state.foodCart,
            menuCategories: state.menuCategories,
            foodList: foods,
            menuSelected: menuSelected);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: menuSelected);
    }
  }

  Stream<DetailPageState> mapUpdateCartToState(FoodCart foodCart) async* {
    yield DetailPageState(
        isVegOnly: state.isVegOnly,
        foodCart: foodCart,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
  }

  Stream<DetailPageState> mapSearchFoodToState(String restaurantId, String keyword) async* {
    yield LoadingSearch(
        foodCart: state.foodCart,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
    try {
      List<Food> result = await repository.getFoods(restaurantId, null, null, keyword);
      if (result.isNotEmpty) {
        yield DetailPageState(
            result: result,
            foodCart: state.foodCart,
            isVegOnly: state.isVegOnly,
            menuCategories: state.menuCategories,
            foodList: state.foodList,
            menuSelected: state.menuSelected);
      } else {
        ErrorSearch("Food item not available",
            foodCart: state.foodCart,
            isVegOnly: state.isVegOnly,
            menuCategories: state.menuCategories,
            foodList: state.foodList,
            menuSelected: state.menuSelected);
      }
    } catch (e) {
      ErrorSearch(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
    }
  }
}
