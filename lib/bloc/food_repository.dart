import 'package:flyereats/bloc/food_provider.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';

class FoodRepository {
  FoodProvider foodProvider = FoodProvider();

  Future<List<Food>> getFoodData(bool isVegOnly) async {
    return foodProvider.getData(isVegOnly);
  }

  Future<FoodCart> getSavedDataCart() async {
    return foodProvider.getSavedCart();
  }

  saveDataCart(int id, Food food, int quantity) {
    foodProvider.saveCart(id, food, quantity);
  }

  FoodCart getFoodDataCart() {
    return foodProvider.getCart();
  }
}

class FoodCartRepository {
  FoodCart foodCart = FoodCart(Map<int, FoodCartItem>());

/*
  FoodCartRepository._privateConstructor();

  static final FoodCartRepository _instance =
      FoodCartRepository._privateConstructor();

  factory FoodCartRepository() {
    return _instance;
  }
*/

  void changeQuantity(int id, Food food, int quantity) {
    foodCart.changeQuantity(id, food, quantity);
  }

  void getQuantity(int id) {
    foodCart.getQuantity(id);
  }
}
