import 'package:clients/model/add_on.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/price.dart';

class FoodCart {
  final Map<String, FoodCartItem> cart;

  FoodCart(this.cart);

  bool isFoodExist(String id) {
    return cart.containsKey(id);
  }

  void addFoodToCart(String id, Food food, int quantity, Price price, List<AddOn> addOns) {
    cart[id] = FoodCartItem(id, food, quantity, price, addOns);
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

  void changeQuantity(String id, Food food, int quantity, Price price, List<AddOn> addOns) {
    if (!isFoodExist(id)) {
      addFoodToCart(id, food, 1, price, addOns);
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
      amount = amount + (item.price.price - item.food.discount) * item.quantity;
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
  final Price price;
  final List<AddOn> addOns;

  FoodCartItem(this.id, this.food, this.quantity, this.price, this.addOns);
}
