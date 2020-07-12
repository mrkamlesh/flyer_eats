import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'dart:async';

class FoodProvider {
  final String baseUrl = "";
  final FoodCart foodCart = FoodCart(Map());

  Future<List<Food>> getData(bool isVegOnly) async {
    return ExampleModel.getFoods();
  }

  FoodCart getCart() {
    return foodCart;
  }

  saveCart(String id, Food food, int quantity) {
    //save to shared preference

    //foodCart.changeQuantity(id, food, quantity);
  }

  Future<FoodCart> getSavedCart() async {
    //get from shared preference and add it to current cart

    return foodCart;
  }
}
