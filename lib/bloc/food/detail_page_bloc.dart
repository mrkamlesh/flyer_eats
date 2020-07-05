import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';
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
      yield* mapSwitchVegOnlyToState(event.isVegOnly);
    } else if (event is ChangeQuantity) {
      yield* mapChangeQuantityToState(event.id, event.food, event.quantity);
    } else if (event is RestaurantMenuChange) {
      yield* mapRestaurantMenuChangeToState(event.restaurantId, event.menuId);
    } else if (event is UpdateCart) {
      yield* mapUpdateCartToState(event.foodCart);
    }
  }

  Stream<DetailPageState> mapPageOpenToState(String restaurantId) async* {
    yield OnDataLoading(
        foodCart: state.foodCart,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList);
    try {
      List<MenuCategory> menus = await repository.getCategories(restaurantId);
      List<Food> foods = await repository.getFoods(restaurantId, menus[0].id);

      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: menus, foodCart: state.foodCart, isVegOnly: state.isVegOnly, foodList: List());
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly, foodCart: state.foodCart, menuCategories: menus, foodList: foods);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList);
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(bool isVegOnly) async* {
    yield DetailPageState(
        isVegOnly: isVegOnly, foodCart: state.foodCart, menuCategories: state.menuCategories, foodList: state.foodList);
  }

  Stream<DetailPageState> mapSwitchCategoryToState(String id) async* {}

  Stream<DetailPageState> mapChangeQuantityToState(String id, Food food, int quantity) async* {
    //yield OnDataLoading();
    FoodCart cart = FoodCart(Map.from((state.foodCart).cart));
    cart.changeQuantity(id, food, quantity);

    yield CartState(
        isVegOnly: state.isVegOnly, foodCart: cart, menuCategories: state.menuCategories, foodList: state.foodList);
  }

  Stream<DetailPageState> mapRestaurantMenuChangeToState(String restaurantId, String menuId) async* {
    yield OnDataLoading(
        foodCart: state.foodCart,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList);
    try {
      List<Food> foods = await repository.getFoods(restaurantId, menuId);
      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: state.menuCategories,
            foodCart: state.foodCart,
            isVegOnly: state.isVegOnly,
            foodList: List());
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly,
            foodCart: state.foodCart,
            menuCategories: state.menuCategories,
            foodList: foods);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          foodCart: state.foodCart,
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList);
    }
  }

  Stream<DetailPageState> mapUpdateCartToState(FoodCart foodCart) async* {
    yield DetailPageState(
        isVegOnly: state.isVegOnly, foodCart: foodCart, menuCategories: state.menuCategories, foodList: state.foodList);
  }
}
