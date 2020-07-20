import 'package:clients/model/address.dart';
import 'package:clients/model/pickup.dart';

class PlaceOrderPickup {
  final String token;
  final bool isValid;
  final String message;
  final String id;
  final PickUp pickUp;
  final Address address;
  final String location;
  final String contact;
  final bool isChangePrimaryContact;
  final double deliveryAmount;
  final String razorKey;
  final String razorSecret;
  final String distance;

  PlaceOrderPickup(
      {this.token,
      this.razorKey,
      this.razorSecret,
      this.isValid,
      this.message,
      this.id,
      this.pickUp,
      this.address,
      this.location,
      this.contact,
      this.isChangePrimaryContact,
      this.deliveryAmount,
      this.distance});

  PlaceOrderPickup copyWith(
      {String token,
      String id,
      PickUp pickUp,
      Address address,
      String contact,
      bool isChangePrimaryContact,
      double deliveryAmount,
      bool isValid,
      String message,
      String location,
      String razorKey,
      String razorSecret,
      String distance}) {
    return PlaceOrderPickup(
        token: token ?? this.token,
        isValid: isValid ?? this.isValid,
        message: message ?? this.message,
        address: address ?? this.address,
        pickUp: pickUp ?? this.pickUp,
        id: id ?? this.id,
        location: location ?? this.location,
        isChangePrimaryContact: isChangePrimaryContact ?? this.isChangePrimaryContact,
        contact: contact ?? this.contact,
        deliveryAmount: deliveryAmount ?? this.deliveryAmount,
        razorKey: razorKey ?? this.razorKey,
        razorSecret: razorSecret ?? this.razorSecret,
        distance: distance ?? this.distance);
  }
}
