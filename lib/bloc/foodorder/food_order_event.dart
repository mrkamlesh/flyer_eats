import 'package:equatable/equatable.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FoodOrderEvent extends Equatable {
  const FoodOrderEvent();
}

class InitPlaceOrder extends FoodOrderEvent {
  final Restaurant restaurant;
  final FoodCart foodCart;
  final User user;

  InitPlaceOrder(this.restaurant, this.foodCart, this.user);

  @override
  List<Object> get props => [restaurant, foodCart, user];
}

class ChangeTransactionType extends FoodOrderEvent {
  final String transactionType;

  const ChangeTransactionType(this.transactionType);

  @override
  List<Object> get props => [transactionType];
}

class ChangeAddress extends FoodOrderEvent {
  final Address address;

  const ChangeAddress(this.address);

  @override
  List<Object> get props => [address];
}

class ChangeContactPhone extends FoodOrderEvent {
  final String contact;

  const ChangeContactPhone(this.contact);

  @override
  List<Object> get props => [contact];
}

class ChangeQuantityFoodCart extends FoodOrderEvent {
  final String id;
  final Food food;
  final int quantity;

  const ChangeQuantityFoodCart(this.id, this.food, this.quantity);

  @override
  List<Object> get props => [id, food, quantity];
}
