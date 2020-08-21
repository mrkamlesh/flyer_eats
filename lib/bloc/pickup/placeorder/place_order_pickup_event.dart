import 'package:clients/model/address.dart';
import 'package:clients/model/pickup.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlaceOrderPickupEvent extends Equatable {
  const PlaceOrderPickupEvent();
}

class InitPlaceOrder extends PlaceOrderPickupEvent {
  final String token;
  final PickUp pickUp;
  final Address address;
  final String contact;
  final String location;

  const InitPlaceOrder(this.token, this.pickUp, this.address, this.contact, this.location);

  @override
  List<Object> get props => [token, pickUp, address, contact];
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
