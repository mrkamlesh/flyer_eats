import 'dart:convert';

import 'package:clients/model/add_on.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/price.dart';

class FoodCart {
  final Map<String, FoodCartItem> singleItemCart;
  final List<FoodCartItem> multipleItemCart;

  FoodCart(this.singleItemCart, this.multipleItemCart);

  bool isSingleItemFoodExist(String id) {
    return singleItemCart.containsKey(id);
  }

  void addSingleItemFoodToCart(String id, Food food, int quantity, Price price, List<AddOn> addOns) {
    singleItemCart[id] = FoodCartItem(id, food, quantity, price, addOns);
  }

  int getSingleItemFoodQuantity(String id) {
    if (!isSingleItemFoodExist(id)) {
      return 0;
    } else {
      return singleItemCart[id].quantity;
    }
  }

  void removeSingleItemFood(String id) {
    if (isSingleItemFoodExist(id)) {
      singleItemCart.remove(id);
    }
  }

  void changeSingleItemFoodQuantity(String id, Food food, int quantity, Price price, List<AddOn> addOns) {
    if (!isSingleItemFoodExist(id)) {
      addSingleItemFoodToCart(id, food, 1, price, addOns);
    } else {
      singleItemCart[id].quantity = quantity;
      if (quantity <= 0) {
        singleItemCart.remove(id);
      }
    }
  }

  void addMultipleItemFoodToCart(Food food, int quantity, Price price, List<AddOn> addOns) {
    multipleItemCart.add(FoodCartItem("", food, quantity, price, addOns));
  }

  void removeMultipleItemFoodFromCart(Food food) {
    int removeIndex = multipleItemCart.lastIndexWhere((element) {
      if (element.food.id == food.id) {
        return true;
      }
      return false;
    });

    multipleItemCart.removeAt(removeIndex);
  }

  int getMultipleItemFoodQuantity(String foodId) {
    int total = 0;
    multipleItemCart.forEach((element) {
      if (element.food.id == foodId) {
        total = total + element.quantity;
      }
    });

    return total;
  }

  int getFoodQuantity(Food food) {
    if (food.isSingleItem) {
      return getSingleItemFoodQuantity(food.id);
    } else {
      return getMultipleItemFoodQuantity(food.id);
    }
  }

  double getCartTotalAmount() {
    double amount = 0;

    this.getAllFoodCartItem().forEach((foodCartItem) {
      amount = amount + (foodCartItem.getAmount() * foodCartItem.quantity);
    });

    return amount;
  }

  int cartItemTotal() {
    return this.getAllFoodCartItem().length;
  }

  List<FoodCartItem> getAllFoodCartItem() {
    return this.singleItemCart.entries.map((e) => e.value).toList() + this.multipleItemCart;
  }

  String cartToString() {
    String cartString;

    List<Map<String, dynamic>> list = List();

    this.getAllFoodCartItem().forEach((foodCartItem) {
      Map<String, dynamic> cartItem = Map();
      cartItem['item_id'] = foodCartItem.food.id;
      cartItem['qty'] = foodCartItem.quantity;
      cartItem['price'] = foodCartItem.price.price.toString() + "|" + foodCartItem.food.price.size;
      //cartItem['sub_item'] = List<Map<String, dynamic>>();
      List<Map<String, dynamic>> addOnList = List();
      foodCartItem.addOns.forEach((addOn) {
        Map<String, dynamic> addOnMap = Map();
        addOnMap['subcat_id'] = addOn.addOnsTypeId;
        addOnMap['value'] = addOn.id + "|" + addOn.price.toString() + "|" + addOn.name;
        addOnMap['qty'] = "itemqty"; //addOn.quantity;
        addOnMap['price'] = addOn.price;
        addOnList.add(addOnMap);
      });

      cartItem['sub_item'] = addOnList;
      cartItem['cooking_ref'] = [];
      cartItem['ingredients'] = [];
      cartItem['order_notes'] = '';
      cartItem['discount'] = foodCartItem.food.discount.toString();
      cartItem['category_id'] = foodCartItem.food.category.id;

      list.add(cartItem);
    });

    cartString = jsonEncode(list);

    return cartString;
  }
}

class FoodCartItem {
  final String id;
  final Food food;
  int quantity;
  final Price price;
  final List<AddOn> addOns;

  FoodCartItem(this.id, this.food, this.quantity, this.price, this.addOns);

  String addOnsToString() {
    List<String> addOnsName = List();
    this.addOns.forEach((addOn) {
      addOnsName.add(addOn.name /*+ " (" + addOn.quantity.toString() + ")"*/);
    });

    return addOnsName.join(", ");
  }

  bool hasAddOns() {
    return this.addOns.length > 0;
  }

  double getAmount() {
    double amount = this.price.price - this.food.discount;

    this.addOns.forEach((addOn) {
      amount = amount + (addOn.price * addOn.quantity);
    });

    //amount = amount * this.quantity;

    return amount;
  }
}
