import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/food/food_repository.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';
import 'bloc.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {

  DataRepository repository = DataRepository();

  FoodCartRepository foodCartRepository;

  DetailPageBloc();

  @override
  DetailPageState get initialState => Uninitialized();

  @override
  Stream<DetailPageState> mapEventToState(
    DetailPageEvent event,
  ) async* {
    print(event);
    if (event is PageDetailRestaurantOpen) {
      yield* mapPageOpenToState(event.restaurantId);
    } else if (event is SwitchVegOnly) {
      yield* mapSwitchVegOnlyToState(event.isVegOnly);
    } else if (event is ChangeQuantity) {
      yield* mapChangeQuantityToState(event.id, event.food, event.quantity);
    } else if (event is RestaurantMenuChange) {
      yield* mapRestaurantMenuChangeToState(event.restaurantId, event.menuId);
    }
  }

  Stream<DetailPageState> mapPageOpenToState(String restaurantId) async* {
    foodCartRepository = FoodCartRepository();
    //FoodCart cart = FoodCart(Map<int, FoodCartItem>());
    yield CartState(foodCartRepository.foodCart);
    yield OnDataLoading();
    try {
      List<MenuCategory> menus =
          await repository.getCategories(restaurantId);
      List<Food> foods =
          await repository.getFoods(restaurantId, menus[0].id);
      yield MenusLoaded(menus);
      if (foods.isEmpty){
        yield NoFoodAvailable();
      } else {
        yield OnDataLoaded(foods);
      }
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(bool isVegOnly) async* {

  }

  Stream<DetailPageState> mapSwitchCategoryToState(String id) async* {

  }

  Stream<DetailPageState> mapChangeQuantityToState(
      String id, Food food, int quantity) async* {
    //yield OnDataLoading();
    foodCartRepository.foodCart.changeQuantity(id, food, quantity);
    FoodCart cart = FoodCart(Map.from((foodCartRepository.foodCart).cart));

    yield CartState(cart);
  }

  Stream<DetailPageState> mapRestaurantMenuChangeToState(
      String restaurantId, String menuId) async* {
    yield OnDataLoading();
    try {
      List<Food> foods = await repository.getFoods(restaurantId, menuId);
      if (foods.isEmpty){
        yield NoFoodAvailable();
      } else {
        yield OnDataLoaded(foods);
      }
    } catch (e) {
      yield OnDataError(e.toString());
    }
  }
}
