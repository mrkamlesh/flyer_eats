import 'package:clients/model/address.dart';
import 'package:clients/model/pickup.dart';
import 'package:clients/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlaceOrderPickupEvent extends Equatable {
  const PlaceOrderPickupEvent();
}

class InitPlaceOrder extends PlaceOrderPickupEvent {
  final User user;
  final PickUp pickUp;
  final Address address;
  final String contact;
  final String location;

  const InitPlaceOrder(
      this.user, this.pickUp, this.address, this.contact, this.location);

  @override
  List<Object> get props => [user, pickUp, address, contact];
}

class GetDeliveryCharge extends PlaceOrderPickupEvent {
  const GetDeliveryCharge();

  @override
  List<Object> get props => [];
}

class ChangeAddress extends PlaceOrderPickupEvent {
  final Address address;

  const ChangeAddress(this.address);

  @override
  List<Object> get props => [address];
}

class ChangeContact extends PlaceOrderPickupEvent {
  final String contact;
  final bool isChangePrimaryContact;

  const ChangeContact(this.contact, this.isChangePrimaryContact);

  @override
  List<Object> get props => [contact, isChangePrimaryContact];
}

class SelectPaymentMethod extends PlaceOrderPickupEvent {
  final String selectedPaymentMethod;

  const SelectPaymentMethod(this.selectedPaymentMethod);

  @override
  List<Object> get props => [selectedPaymentMethod];
}

class ChangePaymentReference extends PlaceOrderPickupEvent {
  final String paymentReference;

  const ChangePaymentReference(this.paymentReference);

  @override
  List<Object> get props => [paymentReference];
}

class RequestOtpChangeContact extends PlaceOrderPickupEvent {
  final bool isChangePrimaryContact;
  final String contact;

  RequestOtpChangeContact(this.isChangePrimaryContact, this.contact);

  @override
  List<Object> get props => [isChangePrimaryContact, contact];
}

class PlaceOrderEvent extends PlaceOrderPickupEvent {
  const PlaceOrderEvent();

  @override
  List<Object> get props => [];
}

class InitCashfreePayment extends PlaceOrderPickupEvent {
  InitCashfreePayment();

  @override
  List<Object> get props => [];
}

class PlaceOrderStripeEvent extends PlaceOrderPickupEvent {
  PlaceOrderStripeEvent();

  @override
  List<Object> get props => [];
}
