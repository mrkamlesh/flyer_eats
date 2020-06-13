import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';

class Order {
  final String id;
  final String title;
  final Restaurant restaurant;
  final FoodCart foodCart;
  final String date;
  final String status;
  final String total;

  Order(
      {this.restaurant,
      this.foodCart,
      this.date,
      this.status,
      this.id,
      this.title,
      this.total});

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    return Order(
      id: parsedJson['order_id'],
      title: parsedJson['title_new'],
      restaurant:
          Restaurant("", parsedJson['merchant_name'], "", "", "", "", ""),
      date: parsedJson['place_on'],
      status: parsedJson['status'],
      total: parsedJson['total'],
      foodCart: FoodCart(Map()),
    );
  }
}
