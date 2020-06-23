import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/restaurant.dart';

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
  final String status;
  final FoodCart foodCart;
  final double total;
  final double subtotal;
  final double deliveryCharges;
  final double packagingFee;
  final double tax;
  final double discountOrder;
  final double discountFood;
  final double voucherAmount;

  DetailOrder({
    this.id,
    this.status,
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
    this.total,
    this.subtotal,
    this.deliveryCharges,
    this.packagingFee,
    this.tax,
    this.discountOrder,
    this.discountFood,
    this.voucherAmount,
  });

  factory DetailOrder.fromJson(Map<String, dynamic> parsedJson) {
    FoodCart foodCart = new FoodCart(Map<String, FoodCartItem>());
    var foodCartItemJson = parsedJson['html']['item'] as List;
    for (int i = 0; i < foodCartItemJson.length; i++) {
      foodCart.addFoodToCart(
          foodCartItemJson[i]['item_id'],
          Food(
              id: foodCartItemJson[i]['id'],
              title: foodCartItemJson[i]['item_name'],
              category: MenuCategory(foodCartItemJson[i]['category_id'],
                  foodCartItemJson[i]['category_name']),
              price:
                  double.parse(foodCartItemJson[i]['normal_price'].toString())),
          foodCartItemJson[i]['qty']);
    }

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
        status: parsedJson['status_raw'],
    );
  }
}
