import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';

class DetailPageState {
  final FoodCart foodCart;
  final List<MenuCategory> menuCategories;
  final bool isVegOnly;
  final List<Food> foodList;
  final int menuSelected;
  final List<Food> result;

  DetailPageState({
    this.foodCart,
    this.menuCategories,
    this.isVegOnly,
    this.foodList,
    this.menuSelected,
    this.result,
  });
}

class Initialize extends DetailPageState {
  Initialize()
      : super(
            foodList: List(),
            isVegOnly: false,
            menuSelected: 0,
            menuCategories: List<MenuCategory>(),
            foodCart: FoodCart(Map()));
}

class OnDataLoading extends DetailPageState {
  OnDataLoading(
      {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected);
}

class OnDataError extends DetailPageState {
  final String error;

  OnDataError(this.error,
      {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected);
}

class NoFoodAvailable extends DetailPageState {
  NoFoodAvailable(
      {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected);
}

class CartState extends DetailPageState {
  CartState(
      {FoodCart foodCart,
      List<MenuCategory> menuCategories,
      bool isVegOnly,
      List<Food> foodList,
      int menuSelected,
      List<Food> result})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected,
            result: result);
}

class LoadingSearch extends DetailPageState {
  LoadingSearch(
      {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected);
}

class SuccessSearch extends DetailPageState {
  SuccessSearch(
      {FoodCart foodCart,
      List<MenuCategory> menuCategories,
      bool isVegOnly,
      List<Food> foodList,
      int menuSelected,
      List<Food> result})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected,
            result: result);
}

class ErrorSearch extends DetailPageState {
  final String message;

  ErrorSearch(this.message,
      {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodCart: foodCart,
            foodList: foodList,
            menuSelected: menuSelected);
}
