import 'package:flyereats/model/food.dart';

class FoodCart {
  final Map<int, FoodCartItem> cart;

  FoodCart(this.cart);

  bool isFoodExist(int id) {
    return cart.containsKey(id);
  }

  void addFoodToCart(int id, Food food, int quantity) {
    cart[id] = FoodCartItem(id, food, quantity);
  }

  int getQuantity(int id) {
    if (!isFoodExist(id)) {
      return 0;
    } else {
      return cart[id].quantity;
    }
  }

  void removeFood(int id) {
    if (isFoodExist(id)) {
      cart.remove(id);
    }
  }

  void changeQuantity(int id, Food food, int quantity) {
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
  final int id;
  final Food food;
  int quantity;

  FoodCartItem(this.id, this.food, this.quantity);
}
