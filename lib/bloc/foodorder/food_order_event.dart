import 'package:clients/model/add_on.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/price.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/voucher.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FoodOrderEvent extends Equatable {
  const FoodOrderEvent();
}

class InitPlaceOrder extends FoodOrderEvent {
  final User user;

  InitPlaceOrder(this.user);

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

class RemoveVoucher extends FoodOrderEvent {
  const RemoveVoucher();

  @override
  List<Object> get props => [];
}

class ChangeQuantityWithPayment extends FoodOrderEvent {
  final FoodCartItem foodCartItem;
  final int quantity;

  const ChangeQuantityWithPayment(this.foodCartItem, this.quantity);

  @override
  List<Object> get props => [foodCartItem];
}

class ChangeQuantityNoPayment extends FoodOrderEvent {
  final Restaurant restaurant;
  final String id;
  final Food food;
  final int quantity;
  final Price price;
  final List<AddOn> addOns;
  final bool isIncrease;

  const ChangeQuantityNoPayment(this.restaurant, this.id, this.food,
      this.quantity, this.price, this.addOns, this.isIncrease);

  @override
  List<Object> get props =>
      [restaurant, id, food, quantity, price, addOns, isIncrease];
}

class PlaceOrderEvent extends FoodOrderEvent {
  PlaceOrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrderStripeEvent extends FoodOrderEvent {
  PlaceOrderStripeEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentOptions extends FoodOrderEvent {
  GetPaymentOptions();

  @override
  List<Object> get props => [];
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

class ClearCart extends FoodOrderEvent {
  ClearCart();

  @override
  List<Object> get props => [];
}

class GetFoodDetail extends FoodOrderEvent {
  final String foodId;

  GetFoodDetail(this.foodId);

  @override
  List<Object> get props => [foodId];
}

class StartEditFoodDetail extends FoodOrderEvent {
  final FoodCartItem cartItem;

  StartEditFoodDetail(this.cartItem);

  @override
  List<Object> get props => [];
}

class UpdateFoodDetail extends FoodOrderEvent {
  final FoodCartItem cartItem;
  final int quantity;
  final Price price;
  final List<AddOn> addOns;

  UpdateFoodDetail(this.cartItem, this.quantity, this.price, this.addOns);

  @override
  List<Object> get props => [cartItem, quantity, price, addOns];
}

class ChangeContactPhone extends FoodOrderEvent {
  final bool isChangePrimaryContact;
  final String contact;

  const ChangeContactPhone(this.isChangePrimaryContact, this.contact);

  @override
  List<Object> get props => [isChangePrimaryContact, contact];
}

class RequestOtpChangeContact extends FoodOrderEvent {
  final bool isChangePrimaryContact;
  final String contact;

  RequestOtpChangeContact(this.isChangePrimaryContact, this.contact);

  @override
  List<Object> get props => [isChangePrimaryContact, contact];
}

class MarkRestaurantHasShownBusyDialog extends FoodOrderEvent {
  final String restaurantId;

  MarkRestaurantHasShownBusyDialog(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}
