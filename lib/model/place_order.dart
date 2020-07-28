import 'dart:convert';

import 'package:clients/model/address.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/payment_method.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/voucher.dart';
import 'package:intl/intl.dart';

class PlaceOrder {
  final String id;
  final bool isValid;
  final String message;
  final Restaurant restaurant;
  final User user;
  final String transactionType;
  final FoodCart foodCart;
  final Address address;
  final Voucher voucher;
  final String selectedPaymentMethod;
  final String razorKey;
  final String razorSecret;
  final String deliveryInstruction;
  final String contact;
  final double deliveryCharges;
  final double packagingCharges;
  final double taxCharges;
  final String taxPrettyString;
  final double discountOrder;
  final String discountOrderPrettyString;
  final bool isUseWallet;
  final double walletAmount;
  final bool isChangePrimaryContact;
  final List<PaymentMethod> listPaymentMethod;
  final DateTime now;
  final DateTime selectedDeliveryTime;

  PlaceOrder({
    this.id,
    this.isValid,
    this.message,
    this.restaurant,
    this.user,
    this.transactionType,
    this.foodCart,
    this.address,
    this.voucher,
    this.selectedPaymentMethod,
    this.razorKey,
    this.razorSecret,
    this.deliveryInstruction,
    this.contact,
    this.deliveryCharges,
    this.packagingCharges,
    this.taxCharges,
    this.taxPrettyString,
    this.discountOrder,
    this.discountOrderPrettyString,
    this.walletAmount,
    this.isUseWallet,
    this.isChangePrimaryContact,
    this.listPaymentMethod,
    this.selectedDeliveryTime,
    this.now,
  });

  factory PlaceOrder.fromJson(Map<String, dynamic> parsedJson) {
    var listPaymentMethod = parsedJson['details']['payment_list'] as List;
    List<PaymentMethod> listPayment = listPaymentMethod.map((i) {
      return PaymentMethod.fromJson(i);
    }).toList();

    return PlaceOrder(
      isValid: true,
      message: parsedJson['msg'],
      discountOrder: (parsedJson['details']['cart'] as Map).containsKey('discount')
          ? double.parse(parsedJson['details']['cart']['discount']['amount'].toString())
          : 0,
      discountOrderPrettyString: (parsedJson['details']['cart'] as Map).containsKey('discount')
          ? parsedJson['details']['cart']['discount']['display'].toString()
          : "DISCOUNT ORDER",
      deliveryCharges: (parsedJson['details']['cart'] as Map).containsKey('delivery_charges')
          ? double.parse(parsedJson['details']['cart']['delivery_charges']['amount'].toString())
          : 0,
      packagingCharges: (parsedJson['details']['cart'] as Map).containsKey('packaging')
          ? double.parse(parsedJson['details']['cart']['packaging']['amount'].toString())
          : 0,
      taxCharges: (parsedJson['details']['cart'] as Map).containsKey('tax')
          ? double.parse(parsedJson['details']['cart']['tax']['tax'].toString())
          : 0,
      taxPrettyString: (parsedJson['details']['cart'] as Map).containsKey('tax')
          ? parsedJson['details']['cart']['tax']['tax_pretty']
          : "Tax",
      razorKey: parsedJson['details']['razorpay']['razor_key'],
      razorSecret: parsedJson['details']['razorpay']['razor_secret'],
      walletAmount: double.parse(
        parsedJson['details']['wallet_amount'].toString(),
      ),
      listPaymentMethod: listPayment,
    );
  }

  PlaceOrder copyWith({
    String id,
    bool isValid,
    String message,
    Restaurant restaurant,
    User user,
    String transactionType,
    FoodCart foodCart,
    Address address,
    Voucher voucher,
    String selectedPaymentMethod,
    String razorKey,
    String razorSecret,
    String deliveryInstruction,
    String contact,
    double deliveryCharges,
    double packagingCharges,
    double taxCharges,
    String taxPrettyString,
    double discountOrder,
    String discountOrderPrettyString,
    double walletAmount,
    bool isUseWallet,
    bool isChangePrimaryContact,
    List<PaymentMethod> listPaymentMethod,
    DateTime selectedDeliveryTime,
    DateTime now,
  }) {
    return PlaceOrder(
        id: id ?? this.id,
        isValid: isValid ?? this.isValid,
        message: message ?? this.message,
        restaurant: restaurant ?? this.restaurant,
        user: user ?? this.user,
        transactionType: transactionType ?? this.transactionType,
        address: address ?? this.address,
        contact: contact ?? this.contact,
        deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
        foodCart: foodCart ?? this.foodCart,
        selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
        razorKey: razorKey ?? this.razorKey,
        razorSecret: razorSecret ?? this.razorSecret,
        voucher: voucher ?? this.voucher,
        deliveryCharges: deliveryCharges ?? this.deliveryCharges,
        packagingCharges: packagingCharges ?? this.packagingCharges,
        taxCharges: taxCharges ?? this.taxCharges,
        taxPrettyString: taxPrettyString ?? this.taxPrettyString,
        discountOrder: discountOrder ?? this.discountOrder,
        discountOrderPrettyString: discountOrderPrettyString ?? this.discountOrderPrettyString,
        walletAmount: walletAmount ?? this.walletAmount,
        isUseWallet: isUseWallet ?? this.isUseWallet,
        isChangePrimaryContact: isChangePrimaryContact ?? this.isChangePrimaryContact,
        listPaymentMethod: listPaymentMethod ?? this.listPaymentMethod,
        selectedDeliveryTime: selectedDeliveryTime ?? this.selectedDeliveryTime,
        now: now ?? this.now);
  }

  String getDeliveryDate() {
    return DateFormat('yyyy-MM-dd').format(this.selectedDeliveryTime);
  }

  String getDeliveryDatePretty() {
    return DateFormat('MMM dd, yyyy').format(this.selectedDeliveryTime);
  }

  String getDeliveryTime() {
    return DateFormat('hh:mm a').format(this.selectedDeliveryTime);
  }

  List<DateTime> getDeliveryTimeOptions() {
    List<DateTime> list = List();

    DateTime tresshold = DateTime(
      this.now.year,
      this.now.month,
      this.now.day,
      22,
      this.now.minute,
    );

    DateTime i = DateTime(
      this.now.year,
      this.now.month,
      this.now.day,
      this.now.hour,
      this.now.minute,
      this.now.second,
      this.now.millisecond,
      this.now.microsecond,
    ).add(Duration(minutes: 45));
    do {
      list.add(i);
      i = i.add(Duration(minutes: 15));
    } while (i.isBefore(tresshold));
    return list;
  }

  String cartToString() {
    if (foodCart.cart.length == 0) {
      return "";
    }

    String cartString;

    List<Map<String, dynamic>> list = List();

    foodCart.cart.forEach((key, item) {
      Map<String, dynamic> cartItem = Map();
      cartItem['item_id'] = item.food.id;
      cartItem['qty'] = item.quantity;
      cartItem['price'] = item.price.price.toString() + "|" + item.food.price.size;
      cartItem['sub_item'] = [];
      cartItem['cooking_ref'] = [];
      cartItem['ingredients'] = [];
      cartItem['order_notes'] = '';
      cartItem['discount'] = item.food.discount.toString();
      cartItem['category_id'] = item.food.category.id;

      list.add(cartItem);
    });

    cartString = jsonEncode(list);

    return cartString;
  }

  double subTotal() {
    double subTotal = 0;

    foodCart.cart.forEach((key, item) {
      subTotal = subTotal + item.quantity * item.food.getRealPrice();
    });

    return subTotal;
  }

  double getDiscountFoodTotal() {
    double discountTotal = 0;

    foodCart.cart.forEach((key, item) {
      discountTotal = discountTotal + item.quantity * item.food.discount;
    });

    return discountTotal;
  }

/*  double getOrderTotal() {
    double totalOrder = 0;

    foodCart.cart.forEach((key, item) {
      totalOrder = totalOrder + item.quantity * item.food.getRealPrice();
    });

    return totalOrder;
  }*/

  double getTotal() {
    double total = 0;

    total = subTotal() + deliveryCharges + packagingCharges + taxCharges - discountOrder - voucher.amount;

    if (total < 0) {
      return 0;
    }

    return total;
  }

  double getWalletUsed() {
    if (isUseWallet) {
      if (walletAmount >= getTotal()) {
        return getTotal();
      } else {
        return walletAmount;
      }
    } else {
      return 0;
    }
  }
}
