import 'package:clients/model/food.dart';
import 'package:clients/model/menu_category.dart';

class DetailPageState {
  final List<MenuCategory> menuCategories;
  final bool isVegOnly;
  final List<Food> foodList;
  final int menuSelected;
  final List<Food> result;

  DetailPageState({
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
            menuCategories: List<MenuCategory>(),);
}

class OnDataLoading extends DetailPageState {
  OnDataLoading(
      {List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected);
}

class OnDataError extends DetailPageState {
  final String error;

  OnDataError(this.error,
      {List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected);
}

class NoFoodAvailable extends DetailPageState {
  NoFoodAvailable(
      {List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected);
}

class CartState extends DetailPageState {
  CartState(
      {
      List<MenuCategory> menuCategories,
      bool isVegOnly,
      List<Food> foodList,
      int menuSelected,
      List<Food> result})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected,
            result: result);
}

class LoadingSearch extends DetailPageState {
  LoadingSearch(
      {List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected);
}

class SuccessSearch extends DetailPageState {
  SuccessSearch(
      {
      List<MenuCategory> menuCategories,
      bool isVegOnly,
      List<Food> foodList,
      int menuSelected,
      List<Food> result})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected,
            result: result);
}

class ErrorSearch extends DetailPageState {
  final String message;

  ErrorSearch(this.message,
      {List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList, int menuSelected})
      : super(
            isVegOnly: isVegOnly,
            menuCategories: menuCategories,
            foodList: foodList,
            menuSelected: menuSelected);
}
