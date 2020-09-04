import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/pickup.dart';
import 'package:clients/model/place_order_pickup.dart';
import 'package:clients/model/user.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stripe_payment/stripe_payment.dart';
import './bloc.dart';
import 'package:http/http.dart' as http;

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
      yield* mapInitPlaceOrderToState(event.user, event.pickUp, event.address,
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
    } else if (event is ChangePaymentReference) {
      yield* mapChangePaymentReferenceToState(event.paymentReference);
    } else if (event is SelectPaymentMethod) {
      yield* mapSelectPaymentMethodToState(event.selectedPaymentMethod);
    } else if (event is PlaceOrderStripeEvent) {
      yield* mapPlaceOrderStripeEventToState();
    } else if (event is InitCashfreePayment) {
      yield* mapInitCashfreePaymentToState();
    }
  }

  Stream<PlaceOrderPickupState> mapInitPlaceOrderToState(User user,
      PickUp pickUp, Address address, String contact, String location) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: PlaceOrderPickup(
            user: user,
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
          state.placeOrderPickup.user.token,
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
                stripeSecretKey: result.stripeSecretKey,
                stripePublishKey: result.stripePublishKey,
                distance: result.distance,
                currencyCode: result.currencyCode,
                listPaymentMethod: result.listPaymentMethod,
                deliveryAmount: result.deliveryAmount,
                message: result.message));
      } else {
        yield InvalidPlaceOrder(
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

  Stream<PlaceOrderPickupState> mapChangePaymentReferenceToState(
      String paymentReference) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: state.placeOrderPickup
            .copyWith(paymentReference: paymentReference));
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
            isChangePrimaryContact, state.placeOrderPickup.user.token, false);
        yield SuccessRequestOtpChangeContact(contact, isChangePrimaryContact,
            placeOrderPickup: state.placeOrderPickup);
      } catch (e) {
        yield ErrorRequestOtpChangeContact(e.toString(),
            placeOrderPickup: state.placeOrderPickup);
      }
    }
  }

  Stream<PlaceOrderPickupState> mapSelectPaymentMethodToState(
      String selectedPaymentMethod) async* {
    yield PlaceOrderPickupState(
        placeOrderPickup: state.placeOrderPickup
            .copyWith(selectedPaymentMethod: selectedPaymentMethod));
  }

  Stream<PlaceOrderPickupState> mapPlaceOrderStripeEventToState() async* {
    yield LoadingPlaceOrder(placeOrderPickup: state.placeOrderPickup);

    try {
      StripePayment.setOptions(StripeOptions(
          publishableKey: state.placeOrderPickup.stripePublishKey,
          merchantId: "Flyer Eats",
          androidPayMode: 'test'));

      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      var paymentIntent;

      try {
        Map<String, dynamic> body = {
          'amount':
              (state.placeOrderPickup.deliveryAmount * 100.0).ceil().toString(),
          'currency': state.placeOrderPickup.currencyCode,
          'payment_method_types[]': 'card'
        };
        Map<String, String> headers = {
          'Authorization': 'Bearer ${state.placeOrderPickup.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        };
        var response = await http.post(
            "https://api.stripe.com/v1/payment_intents",
            body: body,
            headers: headers);
        paymentIntent = jsonDecode(response.body);
      } catch (err) {
        print('err charging user: ${err.toString()}');
      }

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));

      if (response.status == 'succeeded') {
        add(ChangePaymentReference(response.paymentIntentId));
        add(PlaceOrderEvent());
      } else {
        yield ErrorPlaceOrder("Payment with Stripe Fail",
            placeOrderPickup: state.placeOrderPickup
                .copyWith(isValid: false, message: "Payment with Stripe Fail"));
      }
    } on PlatformException catch (e) {
      print(e);
      yield CancelledPlaceOrder("Order Cancelled",
          placeOrderPickup: state.placeOrderPickup);
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(),
          placeOrderPickup: state.placeOrderPickup
              .copyWith(isValid: false, message: e.toString()));
    }
  }

  Stream<PlaceOrderPickupState> mapInitCashfreePaymentToState() async* {
    yield LoadingPlaceOrder(placeOrderPickup: state.placeOrderPickup);
    try {
      Map<String, String> result = await repository.initCashfreePayment(
          state.placeOrderPickup.user.token,
          state.placeOrderPickup.deliveryAmount.toString(),
          state.placeOrderPickup.currencyCode);

      Map<String, dynamic> inputParams = {
        "orderId": result['order_id'],
        "orderAmount": state.placeOrderPickup.deliveryAmount.toString(),
        "customerName": state.placeOrderPickup.user.name,
        "orderCurrency": state.placeOrderPickup.currencyCode,
        "appId": result['app_id'],
        "tokenData": result['token'],
        "customerPhone": state.placeOrderPickup.user.phone,
        "customerEmail": state.placeOrderPickup.user.username,
        "stage": "TEST"
        //"stage": "PROD"
      };

      Map<dynamic, dynamic> map = await CashfreePGSDK.doPayment(inputParams);

      if (map['txStatus'] == 'SUCCESS') {
        add(ChangePaymentReference(map['referenceId']));
        add(PlaceOrderEvent());
      } else if (map['txStatus'] == 'CANCELLED') {
        yield CancelledPlaceOrder("Order Cancelled",
            placeOrderPickup: state.placeOrderPickup);
      } else {
        yield ErrorPlaceOrder("Payment Fail. Please try another payment method",
            placeOrderPickup: state.placeOrderPickup);
      }
    } catch (e) {
      yield CashFreePaymentFail(e.toString(),
          placeOrderPickup: state.placeOrderPickup);
    }
  }
}
