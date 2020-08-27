import 'package:clients/model/place_order_pickup.dart';

class PlaceOrderPickupState {
  final PlaceOrderPickup placeOrderPickup;

  PlaceOrderPickupState({this.placeOrderPickup});
}

class InitialPlaceOrderPickupState extends PlaceOrderPickupState {
  InitialPlaceOrderPickupState() : super();
}

class LoadingGetDeliveryCharge extends PlaceOrderPickupState {
  LoadingGetDeliveryCharge({PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class InvalidPlaceOrder extends PlaceOrderPickupState {
  InvalidPlaceOrder({PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class LoadingPlaceOrder extends PlaceOrderPickupState {
  LoadingPlaceOrder({PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class SuccessPlaceOrder extends PlaceOrderPickupState {
  SuccessPlaceOrder({PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class ErrorPlaceOrder extends PlaceOrderPickupState {
  final String message;

  ErrorPlaceOrder(this.message, {PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class LoadingRequestOtpChangeContact extends PlaceOrderPickupState {
  LoadingRequestOtpChangeContact({PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class SuccessRequestOtpChangeContact extends PlaceOrderPickupState {
  final String newContact;
  final bool isChangePrimaryContact;

  SuccessRequestOtpChangeContact(this.newContact, this.isChangePrimaryContact,
      {PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}

class ErrorRequestOtpChangeContact extends PlaceOrderPickupState {
  final String message;

  ErrorRequestOtpChangeContact(this.message,
      {PlaceOrderPickup placeOrderPickup})
      : super(placeOrderPickup: placeOrderPickup);
}
