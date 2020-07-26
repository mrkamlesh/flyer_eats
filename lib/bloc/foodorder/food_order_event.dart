import 'package:clients/model/food_cart.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/voucher.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FoodOrderEvent extends Equatable {
  const FoodOrderEvent();
}

class InitPlaceOrder extends FoodOrderEvent {
  InitPlaceOrder();

  @override
  List<Object> get props => [];
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
  final bool isChangePrimaryContact;
  final String contact;

  const ChangeContactPhone(this.isChangePrimaryContact, this.contact);

  @override
  List<Object> get props => [isChangePrimaryContact, contact];
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

class ChangeQuantityWithPayment extends FoodOrderEvent {
  final String id;
  final Food food;
  final int quantity;
  final int selectedPrice;

  const ChangeQuantityWithPayment(this.id, this.food, this.quantity, this.selectedPrice);

  @override
  List<Object> get props => [id, food, quantity, selectedPrice];
}

class ChangeQuantityNoPayment extends FoodOrderEvent {
  final String id;
  final Food food;
  final int quantity;
  final int selectedPrice;

  const ChangeQuantityNoPayment(this.id, this.food, this.quantity, this.selectedPrice);

  @override
  List<Object> get props => [id, food, quantity, selectedPrice];
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

class ChangeDeliveryTime extends FoodOrderEvent {
  final DateTime dateTime;

  ChangeDeliveryTime(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class UpdateCartMainData extends FoodOrderEvent {
  final Restaurant restaurant;
  final FoodCart foodCart;
  final User user;

  UpdateCartMainData(this.restaurant, this.foodCart, this.user);

  @override
  List<Object> get props => [restaurant, foodCart, user];
}


