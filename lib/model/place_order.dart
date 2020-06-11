import 'dart:convert';

import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';
import 'package:flyereats/model/voucher.dart';

class PlaceOrder {
  final bool isValid;
  final String message;
  final Restaurant restaurant;
  final User user;
  final String transactionType;
  final FoodCart foodCart;
  final Address address;
  final Voucher voucher;
  final String paymentList;
  final String razorKey;
  final String razorSecret;
  final String deliveryInstruction;
  final String contact;
  final double deliveryCharges;

  PlaceOrder({
    this.isValid,
    this.message,
    this.restaurant,
    this.user,
    this.transactionType,
    this.foodCart,
    this.address,
    this.voucher,
    this.paymentList,
    this.razorKey,
    this.razorSecret,
    this.deliveryInstruction,
    this.contact,
    this.deliveryCharges,
  });

  PlaceOrder copyWith({
    bool isValid,
    String message,
    Restaurant restaurant,
    User user,
    String transactionType,
    FoodCart foodCart,
    Address address,
    Voucher voucher,
    String paymentList,
    String razorKey,
    String razorSecret,
    String deliveryInstruction,
    String contact,
    double deliveryCharges,
  }) {
    return PlaceOrder(
        isValid: isValid ?? this.isValid,
        message: message ?? this.message,
        restaurant: restaurant ?? this.restaurant,
        user: user ?? this.user,
        transactionType: transactionType ?? this.transactionType,
        address: address ?? this.address,
        contact: contact ?? this.contact,
        deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
        foodCart: foodCart ?? this.foodCart,
        paymentList: paymentList ?? this.paymentList,
        razorKey: razorKey ?? this.razorKey,
        razorSecret: razorSecret ?? this.razorSecret,
        voucher: voucher ?? this.voucher,
        deliveryCharges: deliveryCharges ?? this.deliveryCharges);
  }

  String cartToString() {
    if (foodCart.cart.length == 0) {
      return "";
    }

    String cartString;

    List<Map<String, dynamic>> list = List();

    foodCart.cart.forEach((key, item) {
      Map<String, dynamic> cartItem = Map();
      cartItem['item_id'] = item.id;
      cartItem['qty'] = item.quantity;
      cartItem['price'] = item.food.price.toString();
      cartItem['sub_item'] = [];
      cartItem['cooking_ref'] = [];
      cartItem['ingredients'] = [];
      cartItem['order_notes'] = '';
      cartItem['discount'] = item.food.discount.toString();
      cartItem['category_id'] = item.food.categoryId;

      list.add(cartItem);
    });

    cartString = jsonEncode(list);

    return cartString;
  }

  double subTotal() {
    double subTotal = 0;

    foodCart.cart.forEach((key, item) {
      subTotal =
          subTotal + item.quantity * (item.food.price - item.food.discount);
    });

    return subTotal;
  }

  double getDiscountTotal() {
    double discountTotal = 0;

    foodCart.cart.forEach((key, item) {
      discountTotal = discountTotal + item.quantity * item.food.discount;
    });

    return discountTotal;
  }

  double getOrderTotal() {
    double totalOrder = 0;

    foodCart.cart.forEach((key, item) {
      totalOrder = totalOrder + item.quantity * item.food.price;
    });

    return totalOrder;
  }

  double getTotal() {
    double total = 0;

    total =
        getOrderTotal() - getDiscountTotal() + deliveryCharges - voucher.amount;

    return total;
  }
}
