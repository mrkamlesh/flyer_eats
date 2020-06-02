import 'package:flyereats/model/food.dart';

class FoodCart {
  final Map<String, FoodCartItem> cart;

  FoodCart(this.cart);

  bool isFoodExist(String id) {
    return cart.containsKey(id);
  }

  void addFoodToCart(String id, Food food, int quantity) {
    cart[id] = FoodCartItem(id, food, quantity);
  }

  int getQuantity(String id) {
    if (!isFoodExist(id)) {
      return 0;
    } else {
      return cart[id].quantity;
    }
  }

  void removeFood(String id) {
    if (isFoodExist(id)) {
      cart.remove(id);
    }
  }

  void changeQuantity(String id, Food food, int quantity) {
    if (!isFoodExist(id)) {
      addFoodToCart(id, food, 1);
    } else {
      cart[id].quantity = quantity;
      if (quantity <= 0) {
        cart.remove(id);
      }
    }
  }
}

class FoodCartItem {
  final String id;
  final Food food;
  int quantity;

  FoodCartItem(this.id, this.food, this.quantity);
}
