import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';

class DetailPageState {
  final FoodCart foodCart;
  final List<MenuCategory> menuCategories;
  final bool isVegOnly;
  final List<Food> foodList;

  DetailPageState({
    this.foodCart,
    this.menuCategories,
    this.isVegOnly,
    this.foodList,
  });
}

class Initialize extends DetailPageState {
  Initialize()
      : super(foodList: List(), isVegOnly: false, menuCategories: List<MenuCategory>(), foodCart: FoodCart(Map()));
}

class OnDataLoading extends DetailPageState {
  OnDataLoading({FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList})
      : super(isVegOnly: isVegOnly, menuCategories: menuCategories, foodCart: foodCart, foodList: foodList);
}

class OnDataError extends DetailPageState {
  final String error;

  OnDataError(this.error, {FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList})
      : super(isVegOnly: isVegOnly, menuCategories: menuCategories, foodCart: foodCart, foodList: foodList);
}

class NoFoodAvailable extends DetailPageState {
  NoFoodAvailable({FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList})
      : super(isVegOnly: isVegOnly, menuCategories: menuCategories, foodCart: foodCart, foodList: foodList);
}

class CartState extends DetailPageState {
  CartState({FoodCart foodCart, List<MenuCategory> menuCategories, bool isVegOnly, List<Food> foodList})
      : super(isVegOnly: isVegOnly, menuCategories: menuCategories, foodCart: foodCart, foodList: foodList);
}
