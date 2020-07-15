import 'package:clients/model/food.dart';

class FoodCart {
  final Map<String, FoodCartItem> cart;

  FoodCart(this.cart);

  bool isFoodExist(String id) {
    return cart.containsKey(id);
  }

  void addFoodToCart(String id, Food food, int quantity, int selectedPrice) {
    cart[id] = FoodCartItem(id, food, quantity, selectedPrice);
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

  int getSelectedPrice(String foodId) {
    if (isFoodExist(foodId)) {
      return cart[foodId].selectedPrice;
    } else {
      return 0;
    }
  }

  void changeQuantity(String id, Food food, int quantity, int selectedPrice) {
    if (!isFoodExist(id)) {
      addFoodToCart(id, food, 1, selectedPrice);
    } else {
      cart[id].quantity = quantity;
      if (quantity <= 0) {
        cart.remove(id);
      }
    }
  }

  double getAmount() {
    double amount = 0;
    this.cart.forEach((i, item) {
      amount = amount + item.food.getRealPrice(item.selectedPrice) * item.quantity;
    });

    return amount;
  }

  int cartItemNumber() {
    return this.cart.length;
  }
}

class FoodCartItem {
  final String id;
  final Food food;
  int quantity;
  final int selectedPrice;

  FoodCartItem(this.id, this.food, this.quantity, this.selectedPrice);
}
