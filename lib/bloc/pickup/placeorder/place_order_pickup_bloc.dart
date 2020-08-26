import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/pickup.dart';
import 'package:clients/model/place_order_pickup.dart';
import 'package:sms_autofill/sms_autofill.dart';
import './bloc.dart';

class PlaceOrderPickupBloc
    extends Bloc<PlaceOrderPickupEvent, PlaceOrderPickupState> {
  DataRepository repository = DataRepository();

  @override
  PlaceOrderPickupState get initialState => InitialPlaceOrderPickupState();

  @override
  Stream<PlaceOrderPickupState> mapEventToState(
    PlaceOrderPickupEvent event,
  ) async* {
    if (event is InitPlaceOrder) {
      yield* mapInitPlaceOrderToState(event.token, event.pickUp, event.address,
          event.contact, event.location);
    } else if (event is GetDeliveryCharge) {
      yield* mapGetDeliveryChargeToState();
    } else if (event is ChangeAddress) {
      yield* mapChangeAddressToState(event.address);
    } else if (event is ChangeContact) {
      yield* mapChangeContactToState(
          event.contact, event.isChangePrimaryContact);
    } else if (event is PlaceOrderEvent) {
      yield* mapPlaceOrderEventToState();
    } else if (event is RequestOtpChangeContact) {
      yield* mapRequestOtpChangeContactToState(
          event.contact, event.isChangePrimaryContact);
    }
  }

  Stream<PlaceOrderPickupState> mapInitPlaceOrderToState(String token,
      PickUp pickUp, Address address, String contact, String location) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: PlaceOrderPickup(
            token: token,
            pickUp: pickUp,
            address: address,
            contact: contact,
            deliveryAmount: 0,
            isValid: false,
            isChangePrimaryContact: false,
            location: location));
    add(GetDeliveryCharge());
  }

  Stream<PlaceOrderPickupState> mapGetDeliveryChargeToState() async* {
    yield LoadingGetDeliveryCharge(
        placeOrderPickup:
            state.placeOrderPickup.copyWith(isValid: false, message: null));
    try {
      PlaceOrderPickup result = await repository.getDeliveryCharge(
          state.placeOrderPickup.token,
          state.placeOrderPickup.address.latitude,
          state.placeOrderPickup.address.longitude,
          state.placeOrderPickup.pickUp.shop.lat.toString(),
          state.placeOrderPickup.pickUp.shop.long.toString(),
          state.placeOrderPickup.location);
      if (result.isValid) {
        yield PlaceOrderPickupState(
            placeOrderPickup: state.placeOrderPickup.copyWith(
                isValid: true,
                razorKey: result.razorKey,
                razorSecret: result.razorSecret,
                distance: result.distance,
                currencyCode: result.currencyCode,
                deliveryAmount: result.deliveryAmount,
                message: result.message));
      } else {
        yield PlaceOrderPickupState(
            placeOrderPickup: state.placeOrderPickup.copyWith(
                isValid: false,
                razorKey: null,
                razorSecret: null,
                deliveryAmount: 0,
                message: result.message));
      }
    } catch (e) {
      yield PlaceOrderPickupState(
          placeOrderPickup: state.placeOrderPickup.copyWith(
              message: e.toString(), isValid: false, deliveryAmount: 0));
    }
  }

  Stream<PlaceOrderPickupState> mapChangeAddressToState(
      Address address) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: state.placeOrderPickup.copyWith(address: address));
    add(GetDeliveryCharge());
  }

  Stream<PlaceOrderPickupState> mapChangeContactToState(
      String contact, bool isChangePrimaryContact) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: state.placeOrderPickup.copyWith(
            contact: contact, isChangePrimaryContact: isChangePrimaryContact));
  }

  Stream<PlaceOrderPickupState> mapPlaceOrderEventToState() async* {
    yield LoadingPlaceOrder(placeOrderPickup: state.placeOrderPickup);
    try {
      String result = await repository.placeOrderPickup(state.placeOrderPickup);
      yield SuccessPlaceOrder(
          placeOrderPickup: state.placeOrderPickup.copyWith(id: result));
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(),
          placeOrderPickup: state.placeOrderPickup);
    }
  }

  Stream<PlaceOrderPickupState> mapRequestOtpChangeContactToState(
      contact, isChangePrimaryContact) async* {
    if (contact == state.placeOrderPickup.contact) {
      yield ErrorRequestOtpChangeContact(
          "You have entered the same contact number",
          placeOrderPickup: state.placeOrderPickup);
    } else {
      yield LoadingRequestOtpChangeContact(
          placeOrderPickup: state.placeOrderPickup);
      try {
        String otpSignature = await SmsAutoFill().getAppSignature;
        await repository.requestOtpChangeContactPhone(contact, otpSignature,
            isChangePrimaryContact, state.placeOrderPickup.token);
        yield SuccessRequestOtpChangeContact(contact, isChangePrimaryContact,
            placeOrderPickup: state.placeOrderPickup);
      } catch (e) {
        yield ErrorRequestOtpChangeContact(e.toString(),
            placeOrderPickup: state.placeOrderPickup);
      }
    }
  }
}
