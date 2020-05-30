import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';

class Order {
  final Restaurant restaurant;
  final FoodCart foodCart;
  final String date;
  final String status;

  Order(this.restaurant, this.foodCart, this.date, this.status);
}
