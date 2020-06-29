import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/status_order.dart';

class DetailOrder {
  final String id;
  final String orderInstruction;
  final String username;
  final Restaurant restaurant;
  final String transactionType;
  final String transferDate;
  final String createdDate;
  final String deliveryDate;

  //final String deliveryTime;
  final String deliveryAddress;
  final String deliveryAddressName;
  final String deliveryContact;
  final String restaurantContactNumber;
  final FoodCart foodCart;

  //this is field fee
  final double grandTotal;
  final double subtotal;
  final double deliveryCharges;
  final double packagingFee;
  final double tax;
  final double discountOrder;
  final double discountFood;
  final double voucherAmount;
  final double total;

  //this is status field
  final List<StatusOrder> statusHistory;
  final StatusOrder currentStatus;

  //review
  final bool isReviewAdded;

  DetailOrder({
    this.id,
    this.total,
    this.currentStatus,
    this.foodCart,
    this.username,
    this.restaurant,
    this.transactionType,
    this.transferDate,
    this.createdDate,
    this.deliveryDate,
    //this.deliveryTime,
    this.deliveryAddress,
    this.deliveryAddressName,
    this.deliveryContact,
    this.orderInstruction,
    this.restaurantContactNumber,
    this.grandTotal,
    this.subtotal,
    this.deliveryCharges,
    this.packagingFee,
    this.tax,
    this.discountOrder,
    this.discountFood,
    this.voucherAmount,
    this.statusHistory,
    this.isReviewAdded,
  });

  StatusOrder getCurrentStatus() {
    return statusHistory.last;
  }

  factory DetailOrder.fromJson(Map<String, dynamic> parsedJson) {
    FoodCart foodCart = new FoodCart(Map<String, FoodCartItem>());
    var foodCartItemJson = parsedJson['html']['item'] as List;
    for (int i = 0; i < foodCartItemJson.length; i++) {
      foodCart.addFoodToCart(
          foodCartItemJson[i]['item_id'] + i.toString(),
          Food(
              id: foodCartItemJson[i]['id'],
              title: foodCartItemJson[i]['item_name'],
              category: MenuCategory(foodCartItemJson[i]['category_id'],
                  foodCartItemJson[i]['category_name']),
              discount:
                  double.parse(foodCartItemJson[i]['discount'].toString()),
              price:
                  double.parse(foodCartItemJson[i]['normal_price'].toString())),
          int.parse(foodCartItemJson[i]['qty'].toString()));
    }

    double discountTotal = 0;
    double totalOrder = 0;
    foodCart.cart.forEach((key, item) {
      discountTotal = discountTotal + item.quantity * item.food.discount;
      totalOrder = totalOrder + item.quantity * item.food.price;
    });
    double subTotalOrder = totalOrder - discountTotal;

    var statusHistoryJson = parsedJson['order_history'] as List;
    List<StatusOrder> statusHistory = statusHistoryJson.map((e) {
      return StatusOrder.fromJson(e);
    }).toList();

    return DetailOrder(
        id: parsedJson['order_id'],
        foodCart: foodCart,
        createdDate: parsedJson['date_created'],
        orderInstruction: parsedJson['delivery_instruction'],
        restaurant: Restaurant(
            parsedJson['merchant_id'],
            parsedJson['marchant_name'],
            parsedJson['delivery_time'],
            "",
            parsedJson['marchant_logo'],
            "",
            parsedJson['address'],
            true),
        deliveryAddress: parsedJson['info']['Deliver to'],
        deliveryAddressName: parsedJson['info']['Location Name'],
        deliveryContact: parsedJson['info']['Contact Number'],
        transferDate: parsedJson['info']['TRN Date'],
        username: parsedJson['info']['Name'],
        transactionType: parsedJson['info']['TRN Type'],
        deliveryDate: parsedJson['info']['Delivery Date'],
        //deliveryTime: parsedJson['info']['Delivery Time'],
        restaurantContactNumber: parsedJson['info']['Telephone'],
        currentStatus: StatusOrder(status: "On the way"),
        grandTotal:
            double.parse(parsedJson['html']['total']['total'].toString()),
        tax: double.parse(
            parsedJson['html']['total']['taxable_total'].toString()),
        deliveryCharges: double.parse(
            parsedJson['html']['total']['delivery_charges'].toString()),
        packagingFee: double.parse(parsedJson['html']['total']
                ['merchant_packaging_charge']
            .toString()),
        voucherAmount: double.parse(
            parsedJson['html']['total']['voucher_value'].toString()),
        discountOrder: double.parse(
            parsedJson['html']['total']['discounted_amount'].toString()),
        discountFood: discountTotal,
        subtotal: subTotalOrder,
        total: totalOrder,
        statusHistory: statusHistory,
        isReviewAdded: parsedJson['is_rating_added']);
  }
}
