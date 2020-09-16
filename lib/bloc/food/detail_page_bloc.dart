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
      yield* mapPageOpenToState(event.restaurantId, event.address);
    } else if (event is SwitchVegOnly) {
      yield* mapSwitchVegOnlyToState(
          event.restaurantId, event.isVegOnly, event.address);
    } else if (event is RestaurantMenuChange) {
      yield* mapRestaurantMenuChangeToState(
          event.restaurantId, event.menuId, event.menuSelected, event.address);
    } else if (event is SearchFood) {
      yield* mapSearchFoodToState(
          event.restaurantId, event.keyword, event.address);
    } else if (event is InitializeSearch) {
      yield* mapInitializeSearchToState();
    }
  }

  Stream<DetailPageState> mapPageOpenToState(
      String restaurantId, String address) async* {
    yield OnDataLoading(
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
    try {
      List<MenuCategory> menus = await repository.getCategories(restaurantId);
      List<Food> foods = await repository.getFoods(
          restaurantId, menus[state.menuSelected].id, false, null, address);

      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: menus,
            isVegOnly: state.isVegOnly,
            foodList: List(),
            menuSelected: state.menuSelected);
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly,
            menuCategories: menus,
            foodList: foods,
            menuSelected: state.menuSelected);
      }
    } catch (e) {
      yield OnDataError("This restaurant not published their menu yet",
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
    }
  }

  Stream<DetailPageState> mapSwitchVegOnlyToState(
      String restaurantId, bool isVegOnly, String address) async* {
    if (state.menuCategories.isNotEmpty) {
      yield OnDataLoading(
          isVegOnly: isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
      try {
        List<Food> foods = await repository.getFoods(
            restaurantId,
            state.menuCategories[state.menuSelected].id,
            isVegOnly,
            null,
            address);

        if (foods.isEmpty) {
          yield NoFoodAvailable(
              menuCategories: state.menuCategories,
              isVegOnly: isVegOnly,
              foodList: List(),
              menuSelected: state.menuSelected);
        } else {
          yield DetailPageState(
              isVegOnly: isVegOnly,
              menuCategories: state.menuCategories,
              foodList: foods,
              menuSelected: state.menuSelected);
        }
      } catch (e) {
        yield OnDataError(e.toString(),
            isVegOnly: isVegOnly,
            menuCategories: state.menuCategories,
            foodList: state.foodList,
            menuSelected: state.menuSelected);
      }
    }
  }

  Stream<DetailPageState> mapSwitchCategoryToState(String id) async* {}

  Stream<DetailPageState> mapRestaurantMenuChangeToState(String restaurantId,
      String menuId, int menuSelected, String address) async* {
    yield OnDataLoading(
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: List(),
        menuSelected: menuSelected);
    try {
      List<Food> foods = await repository.getFoods(
          restaurantId, menuId, state.isVegOnly, null, address);
      if (foods.isEmpty) {
        yield NoFoodAvailable(
            menuCategories: state.menuCategories,
            isVegOnly: state.isVegOnly,
            foodList: List(),
            menuSelected: menuSelected);
      } else {
        yield DetailPageState(
            isVegOnly: state.isVegOnly,
            menuCategories: state.menuCategories,
            foodList: foods,
            menuSelected: menuSelected);
      }
    } catch (e) {
      yield OnDataError(e.toString(),
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: menuSelected);
    }
  }

  Stream<DetailPageState> mapUpdateCartToState(FoodCart foodCart) async* {
    yield DetailPageState(
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
  }

  Stream<DetailPageState> mapSearchFoodToState(
      String restaurantId, String keyword, String address) async* {
    yield LoadingSearch(
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        foodList: state.foodList,
        menuSelected: state.menuSelected);
    try {
      List<Food> result =
          await repository.getFoods(restaurantId, null, null, keyword, address);
      if (result.isNotEmpty) {
        yield DetailPageState(
            result: result,
            isVegOnly: state.isVegOnly,
            menuCategories: state.menuCategories,
            foodList: state.foodList,
            menuSelected: state.menuSelected);
      } else {
        yield ErrorSearch("Food item not available",
            isVegOnly: state.isVegOnly,
            menuCategories: state.menuCategories,
            foodList: state.foodList,
            menuSelected: state.menuSelected);
      }
    } catch (e) {
      yield ErrorSearch(e.toString(),
          isVegOnly: state.isVegOnly,
          menuCategories: state.menuCategories,
          foodList: state.foodList,
          menuSelected: state.menuSelected);
    }
  }

  Stream<DetailPageState> mapInitializeSearchToState() async* {
    yield DetailPageState(
        foodList: state.foodList,
        isVegOnly: state.isVegOnly,
        menuCategories: state.menuCategories,
        menuSelected: state.menuSelected);
  }
}
