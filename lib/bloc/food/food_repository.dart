import 'package:flyereats/bloc/food/food_provider.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';

class FoodRepository {

  FoodRepository();

  FoodProvider foodProvider = FoodProvider();

  Future<List<Food>> getFoodData(bool isVegOnly) async {
    return foodProvider.getData(isVegOnly);
  }

  Future<FoodCart> getSavedDataCart() async {
    return foodProvider.getSavedCart();
  }

  saveDataCart(String id, Food food, int quantity) {
    foodProvider.saveCart(id, food, quantity);
  }

  FoodCart getFoodDataCart() {
    return foodProvider.getCart();
  }
}

class FoodCartRepository {
  FoodCart foodCart = FoodCart(Map<String, FoodCartItem>());
}
