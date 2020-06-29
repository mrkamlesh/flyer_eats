import 'package:equatable/equatable.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/place_order.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';
import 'package:flyereats/model/voucher.dart';
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

class ChangeInstruction extends FoodOrderEvent {
  final String instruction;

  const ChangeInstruction(this.instruction);

  @override
  List<Object> get props => [instruction];
}

class ChangePaymentMethod extends FoodOrderEvent {
  final String paymentMethod;

  const ChangePaymentMethod(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

class ApplyVoucher extends FoodOrderEvent {
  final Voucher voucher;

  const ApplyVoucher(this.voucher);

  @override
  List<Object> get props => [voucher];
}

class ChangeQuantityFoodCart extends FoodOrderEvent {
  final String id;
  final Food food;
  final int quantity;

  const ChangeQuantityFoodCart(this.id, this.food, this.quantity);

  @override
  List<Object> get props => [id, food, quantity];
}

class PlaceOrderEvent extends FoodOrderEvent {
  PlaceOrderEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentOptions extends FoodOrderEvent {
  final PlaceOrder order;

  GetPaymentOptions(this.order);

  @override
  List<Object> get props => [order];
}

class ChangeWalletUsage extends FoodOrderEvent {
  final bool isUseWallet;

  ChangeWalletUsage(this.isUseWallet);

  @override
  List<Object> get props => [isUseWallet];
}
