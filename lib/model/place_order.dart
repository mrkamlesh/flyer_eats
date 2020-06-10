import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';

class PlaceOrder {
  final Restaurant restaurant;
  final User user;
  final String transactionType;
  final FoodCart foodCart;
  final Address address;
  final String voucherCode;
  final double voucherAmount;
  final String voucherType;
  final String paymentList;
  final String razorKey;
  final String razorSecret;
  final String deliveryInstruction;
  final String contact;

  PlaceOrder(
      {this.restaurant,
      this.user,
      this.transactionType,
      this.foodCart,
      this.address,
      this.voucherCode,
      this.voucherAmount,
      this.voucherType,
      this.paymentList,
      this.razorKey,
      this.razorSecret,
      this.deliveryInstruction,
      this.contact});

  PlaceOrder copyWith(
      {Restaurant restaurant,
      User user,
      String transactionType,
      FoodCart foodCart,
      Address address,
      String voucherCode,
      String voucherAmount,
      String voucherType,
      String paymentList,
      String razorKey,
      String razorSecret,
      String deliveryInstruction,
      String contact}) {
    return PlaceOrder(
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
        voucherAmount: voucherAmount ?? this.voucherAmount,
        voucherCode: voucherCode ?? this.voucherCode,
        voucherType: voucherType ?? this.voucherType);
  }
}
