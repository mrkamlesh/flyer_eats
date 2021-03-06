import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/add_on.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/food_detail.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/price.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/voucher.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class FoodOrderBloc extends Bloc<FoodOrderEvent, FoodOrderState> {
  DataRepository repository = DataRepository();

  @override
  FoodOrderState get initialState =>
      NoItemsInCart(shownBusyDialogRestaurantIds: List());

  @override
  Stream<FoodOrderState> mapEventToState(
    FoodOrderEvent event,
  ) async* {
    if (event is InitPlaceOrder) {
      yield* mapInitPlaceOrderToState(event.user);
    } else if (event is ChangeTransactionType) {
      yield* mapChangeTransactionTypeToState(event.transactionType);
    } else if (event is ChangeAddress) {
      yield* mapChangeAddressToState(event.address);
    } else if (event is ChangeContactPhone) {
      yield* mapChangeContactPhoneToState(
          event.isChangePrimaryContact, event.contact);
    } else if (event is ChangeQuantityWithPayment) {
      yield* mapChangeQuantityWithPaymentToState(
          event.foodCartItem, event.quantity);
    } else if (event is ChangeQuantityNoPayment) {
      yield* mapChangeQuantityNoPaymentToState(
          event.restaurant,
          event.id,
          event.food,
          event.quantity,
          event.price,
          event.addOns,
          event.isIncrease);
    } else if (event is ChangeInstruction) {
      yield* mapChangeInstructionToState(event.instruction);
    } else if (event is GetPaymentOptions) {
      yield* mapGetPaymentOptionsToState();
    } else if (event is ApplyVoucher) {
      yield* mapApplyCouponToState(event.voucher);
    } else if (event is ChangePaymentMethod) {
      yield* mapChangePaymentMethodToState(event.paymentMethod);
    } else if (event is PlaceOrderEvent) {
      yield* mapPlaceOrderEventToState();
    } else if (event is ChangeWalletUsage) {
      yield* mapChangeWalletUsageToState(event.isUseWallet);
    } else if (event is ChangeDeliveryTime) {
      yield* mapChangeDeliveryTimeToState(event.dateTime);
    } else if (event is ClearCart) {
      yield* mapClearCartToState();
    } else if (event is GetFoodDetail) {
      yield* mapGetFoodDetailToState(event.foodId);
    } else if (event is StartEditFoodDetail) {
      yield* mapStartEditFoodDetailToState(event.cartItem);
    } else if (event is UpdateFoodDetail) {
      yield* mapUpdateFoodDetailToState(
          event.cartItem, event.quantity, event.price, event.addOns);
    } else if (event is RemoveVoucher) {
      yield* mapRemoveVoucherToState();
    } else if (event is PlaceOrderStripeEvent) {
      yield* mapPlaceOrderStripeEventToState();
    } else if (event is RequestOtpChangeContact) {
      yield* mapRequestOtpChangeContactToState(
          event.contact, event.isChangePrimaryContact);
    } else if (event is MarkRestaurantHasShownBusyDialog) {
      yield* mapMarkRestaurantHasShownBusyDialogToState(event.restaurantId);
    } else if (event is ChangePaymentReference) {
      yield* maChangePaymentReferenceToState(event.paymentReference);
    } else if (event is InitCashfreePayment) {
      yield* mapInitCashfreePaymentToState();
    }
  }

  Stream<FoodOrderState> mapChangeTransactionTypeToState(
      String transactionType) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(transactionType: transactionType));
    add(GetPaymentOptions());
  }

  Stream<FoodOrderState> mapChangeAddressToState(Address address) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(address: address));
    add(GetPaymentOptions());
  }

  Stream<FoodOrderState> mapChangeContactPhoneToState(
      bool isChangePrimaryContact, String contact) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(
            contact: contact, isChangePrimaryContact: isChangePrimaryContact));
  }

  Stream<FoodOrderState> mapChangeQuantityWithPaymentToState(
      FoodCartItem foodCartItem, int quantity) async* {
    FoodCart newCart = state.placeOrder.foodCart;

    if (foodCartItem.food.isSingleItem) {
      newCart.changeSingleItemFoodQuantity(foodCartItem.id, foodCartItem.food,
          quantity, foodCartItem.price, foodCartItem.addOns);
    } else {
      int index = newCart.multipleItemCart.indexOf(foodCartItem);
      if (quantity == 0) {
        newCart.multipleItemCart.removeAt(index);
      } else {
        foodCartItem.quantity = quantity;
        newCart.multipleItemCart[index] = foodCartItem;
      }
    }

    if (newCart.cartItemTotal() > 0) {
      yield FoodOrderState(
          placeOrder: state.placeOrder.copyWith(foodCart: newCart));
      add(GetPaymentOptions());
    } else {
      yield NoItemsInCart(
          shownBusyDialogRestaurantIds:
              state.placeOrder.shownBusyDialogRestaurantIds);
    }
  }

  Stream<FoodOrderState> mapChangeQuantityNoPaymentToState(
      Restaurant selectedRestaurant,
      String id,
      Food food,
      int quantity,
      Price price,
      List<AddOn> addOns,
      bool isIncrease) async* {
    //yield FoodOrderState(placeOrder: state.placeOrder);

    if (selectedRestaurant.id == state.placeOrder.restaurant.id ||
        state.placeOrder.restaurant.id == null) {
      FoodCart newCart = state.placeOrder.foodCart;

      if (food.isSingleItem) {
        newCart.changeSingleItemFoodQuantity(id, food, quantity, price, addOns);
      } else {
        if (isIncrease) {
          newCart.multipleItemCart
              .add(FoodCartItem("", food, quantity, price, addOns));
        } else {
          int index = newCart.multipleItemCart.lastIndexWhere((element) {
            if (element.food.id == food.id) {
              return true;
            }
            return false;
          });

          newCart.multipleItemCart[index].quantity =
              newCart.multipleItemCart[index].quantity - 1;
          if (newCart.multipleItemCart[index].quantity == 0) {
            newCart.multipleItemCart.removeAt(index);
          }
        }

        /*if (isIncrease) {
          newCart.addMultipleItemFoodToCart(food, quantity, price, addOns);
        } else {
          newCart.subtractMultipleItemFoodFromCart(
              food, quantity, price, addOns);
        }*/
      }

      if (newCart.cartItemTotal() > 0) {
        yield CartChangeState(
            placeOrder: state.placeOrder
                .copyWith(foodCart: newCart, restaurant: selectedRestaurant));
      } else {
        yield NoItemsInCart(
            shownBusyDialogRestaurantIds:
                state.placeOrder.shownBusyDialogRestaurantIds);
      }
    } else {
      yield ConfirmCartState(
          selectedRestaurant, id, food, quantity, price, addOns,
          placeOrder: state.placeOrder);
    }
  }

  Stream<FoodOrderState> mapInitPlaceOrderToState(User user) async* {
    if (!(state is NoItemsInCart)) {
      DateTime now = DateTime.now();
      yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(
            user: user,
            isValid: true,
            address: user.defaultAddress,
            contact: state.placeOrder.contact ?? user.phone,
            isBusy: state.placeOrder.restaurant.isBusy,
            transactionType:
                state.placeOrder.restaurant.isBusy ? 'pickup' : 'delivery',
            deliveryInstruction: '',
            deliveryCharges: 0,
            voucher: Voucher(amount: 0, rate: 0),
            selectedPaymentMethod: "",
            discountOrder: 0,
            discountOrderPrettyString: "DISCOUNT ORDER",
            taxCharges: 0,
            packagingCharges: 0,
            taxPrettyString: "Tax",
            isUseWallet: false,
            walletAmount: 0,
            isChangePrimaryContact: false,
            isDeliveryEnabled: true,
            isSelfPickupEnabled: true,
            now: now,
            selectedDeliveryTime: now.add(Duration(minutes: 45))),
      );

      add(GetPaymentOptions());
    }
  }

  Stream<FoodOrderState> mapChangeInstructionToState(
      String instruction) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(deliveryInstruction: instruction));
  }

  Stream<FoodOrderState> maChangePaymentReferenceToState(
      String paymentReference) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(paymentReference: paymentReference));
  }

  Stream<FoodOrderState> mapGetPaymentOptionsToState() async* {
    yield LoadingGetPayments(
        placeOrder: state.placeOrder.copyWith(isValid: false));
    try {
      PlaceOrder result = await repository.getPaymentOptions(state.placeOrder);

      if (result.isValid) {
        PlaceOrder currentStatePlaceOrder = state.placeOrder.copyWith(
            isValid: true,
            isMerchantOpen: result.isMerchantOpen,
            message: result.message,
            razorKey: result.razorKey,
            razorSecret: result.razorSecret,
            stripePublishKey: result.stripePublishKey,
            stripeSecretKey: result.stripeSecretKey,
            taxCharges: result.taxCharges,
            packagingCharges: result.packagingCharges,
            taxPrettyString: result.taxPrettyString,
            discountOrder: result.discountOrder,
            discountOrderPrettyString: result.discountOrderPrettyString,
            deliveryCharges: result.deliveryCharges,
            walletAmount: result.walletAmount,
            listPaymentMethod: result.listPaymentMethod,
            applyVoucherMessage: result.applyVoucherErrorMessage,
            isBusy: result.isBusy,
            isVoucherEnabled: result.isVoucherEnabled,
            isSelfPickupEnabled: result.isSelfPickupEnabled,
            isDeliveryEnabled: result.isDeliveryEnabled,
            voucher: result.voucher ??
                state.placeOrder.voucher.copyWith(amount: 0, rate: 0));

        String transactionType = "";

        //Kalau dua delivery dan pickup is true, maka transaction type mengikuti nilai dari state sebelumnya
        //kecuali jika state sebelumnya payment OFF dan sekarang ON maka paksa ke delivery

        //Kalau hanya salah satu delivery atau pickup yang true, maka paksa ke salah satu nilai yang true

        //Kalau hanya tidak ada yang true, lempar state no service available
        //kondisi di atas (if !placeorder.isBusy) berlaku kalau payment ON

        //kondisi di bawah (else) berlaku kalau payment OFF, kalau ada self pickup maka paksa ke nilai itu
        //kalau gak ada maka lemapr no service available

        //POTENSI BUG
        //jika payment method di OFF kan dari admin panel dan user sedang memilih delivery maka order jadi invalid,
        //padahal seharusnya order valid tetapi di paksa ke self-pickup
        //solusi ubah api jadikan order valid jika payment OFF dan transaction type delivery

        if (!(result.isBusy)) {
          if (result.isDeliveryEnabled && result.isSelfPickupEnabled) {
            if (state.placeOrder.isBusy) {
              transactionType = "delivery";
            } else {
              transactionType = state.placeOrder.transactionType;
            }
            yield FoodOrderState(
                placeOrder: currentStatePlaceOrder.copyWith(
                    transactionType: transactionType));
          } else if (!(result.isDeliveryEnabled) &&
              result.isSelfPickupEnabled) {
            transactionType = "pickup";
            yield FoodOrderState(
                placeOrder: currentStatePlaceOrder.copyWith(
                    transactionType: transactionType));
          } else if (result.isDeliveryEnabled &&
              !(result.isSelfPickupEnabled)) {
            transactionType = "delivery";
            yield FoodOrderState(
                placeOrder: currentStatePlaceOrder.copyWith(
                    transactionType: transactionType));
          } else {
            yield NoAvailableService(placeOrder: state.placeOrder);
          }
        } else {
          if (result.isSelfPickupEnabled) {
            transactionType = "pickup";
            yield FoodOrderState(
                placeOrder: currentStatePlaceOrder.copyWith(
                    transactionType: transactionType));
          } else {
            yield NoAvailableService(placeOrder: state.placeOrder);
          }
        }
        if (transactionType != state.placeOrder.transactionType) {
          add(GetPaymentOptions());
        }
      } else {
        if (result.isMerchantOpen) {
          yield InvalidPlaceOrder(
              placeOrder: state.placeOrder.copyWith(
            isValid: false,
            message: result.message,
          ));
        } else {
          yield MerchantIsClosed(
              placeOrder: state.placeOrder.copyWith(
                  isValid: false,
                  message: result.message,
                  isMerchantOpen: result.isMerchantOpen));
        }
      }
    } catch (e) {
      yield FoodOrderState(
          placeOrder:
              state.placeOrder.copyWith(isValid: false, message: e.toString()));
    }
  }

  Stream<FoodOrderState> mapApplyCouponToState(Voucher voucher) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(voucher: voucher));
  }

  Stream<FoodOrderState> mapChangePaymentMethodToState(
      String paymentMethod) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(selectedPaymentMethod: paymentMethod));
  }

  Stream<FoodOrderState> mapPlaceOrderEventToState() async* {
    yield LoadingPlaceOrder(placeOrder: state.placeOrder);
    try {
      PlaceOrder placeOrder = await repository.placeOrder(state.placeOrder);

      //PlaceOrder placeOrder = PlaceOrder(id: "55919");

      if (placeOrder.id != null) {
        yield SuccessPlaceOrder(
            placeOrder: state.placeOrder
                .copyWith(id: placeOrder.id, message: placeOrder.message));
      } else {
        yield ErrorPlaceOrder(placeOrder.message,
            placeOrder: state.placeOrder
                .copyWith(isValid: false, message: placeOrder.message));
      }
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(),
          placeOrder: state.placeOrder.copyWith());
    }
  }

  Stream<FoodOrderState> mapChangeWalletUsageToState(bool isUseWallet) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(isUseWallet: isUseWallet));
  }

  Stream<FoodOrderState> mapChangeDeliveryTimeToState(
      DateTime dateTime) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(selectedDeliveryTime: dateTime));
  }

  Stream<FoodOrderState> mapClearCartToState() async* {
    yield NoItemsInCart(
        shownBusyDialogRestaurantIds:
            state.placeOrder.shownBusyDialogRestaurantIds);
  }

  Stream<FoodOrderState> mapGetFoodDetailToState(foodId) async* {
    yield LoadingGetFoodDetail(placeOrder: state.placeOrder);

    try {
      var result = await repository.getFoodDetail(foodId);
      if (result is FoodDetail) {
        yield SuccessGetFoodDetail(result, placeOrder: state.placeOrder);
      } else {
        yield ErrorGetFoodDetail(result as String,
            placeOrder: state.placeOrder);
      }
    } catch (e) {
      yield ErrorGetFoodDetail(e.toString(), placeOrder: state.placeOrder);
    }
  }

  Stream<FoodOrderState> mapStartEditFoodDetailToState(
      FoodCartItem cartItem) async* {
    yield LoadingGetFoodDetail(placeOrder: state.placeOrder);

    try {
      var result = await repository.getFoodDetail(cartItem.food.id);
      if (result is FoodDetail) {
        cartItem.addOns.forEach((cartAddOn) {
          for (int i = 0; i < result.addOnsTypes.length; i++) {
            if (result.addOnsTypes[i].id == cartAddOn.addOnsTypeId) {
              for (int j = 0; j < result.addOnsTypes[i].addOns.length; j++) {
                if (result.addOnsTypes[i].addOns[j].id == cartAddOn.id) {
                  result.addOnsTypes[i].addOns[j].isSelected =
                      cartAddOn.isSelected;
                  result.addOnsTypes[i].addOns[j].quantity = cartAddOn.quantity;
                }
              }
            }
          }
        });
        yield SuccessGetFoodDetail(result, placeOrder: state.placeOrder);
      } else {
        yield ErrorGetFoodDetail(result as String,
            placeOrder: state.placeOrder);
      }
    } catch (e) {
      yield ErrorGetFoodDetail(e.toString(), placeOrder: state.placeOrder);
    }
  }

  Stream<FoodOrderState> mapUpdateFoodDetailToState(FoodCartItem cartItem,
      int quantity, Price price, List<AddOn> addOns) async* {
    FoodCart foodCart = state.placeOrder.foodCart;

    int index = foodCart.multipleItemCart.indexOf(cartItem);

    foodCart.multipleItemCart[index] =
        FoodCartItem(cartItem.id, cartItem.food, quantity, price, addOns);

    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(foodCart: foodCart));

    add(GetPaymentOptions());
  }

  Stream<FoodOrderState> mapRemoveVoucherToState() async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(voucher: Voucher(amount: 0, rate: 0)));
    add(GetPaymentOptions());
  }

  Stream<FoodOrderState> mapPlaceOrderStripeEventToState() async* {
    yield LoadingPlaceOrder(placeOrder: state.placeOrder);

    try {
      StripePayment.setOptions(StripeOptions(
          publishableKey: state.placeOrder.stripePublishKey,
          merchantId: "Flyer Eats",
          androidPayMode: 'test'));

      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      var paymentIntent;

      try {
        Map<String, dynamic> body = {
          'amount': (state.placeOrder.getTotal() * 100.0).ceil().toString(),
          'currency': state.placeOrder.restaurant.currencyCode,
          'payment_method_types[]': 'card'
        };
        Map<String, String> headers = {
          'Authorization': 'Bearer ${state.placeOrder.stripeSecretKey}',
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
            placeOrder: state.placeOrder
                .copyWith(isValid: false, message: "Payment with Stripe Fail"));
      }
    } on PlatformException catch (e) {
      print(e);
      yield CancelledPlaceOrder("Order Cancelled",
          placeOrder: state.placeOrder);
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(),
          placeOrder:
              state.placeOrder.copyWith(isValid: false, message: e.toString()));
    }
  }

  Stream<FoodOrderState> mapRequestOtpChangeContactToState(
      String contact, bool isChangePrimaryContact) async* {
    if (contact == state.placeOrder.contact) {
      yield ErrorRequestOtpChangeContact(
          "You have entered the same contact number",
          placeOrder: state.placeOrder);
    } else {
      yield LoadingRequestOtpChangeContact(placeOrder: state.placeOrder);
      try {
        String otpSignature = await SmsAutoFill().getAppSignature;
        await repository.requestOtpChangeContactPhone(contact, otpSignature,
            isChangePrimaryContact, state.placeOrder.user.token, false);
        yield SuccessRequestOtpChangeContact(contact, isChangePrimaryContact,
            placeOrder: state.placeOrder);
      } catch (e) {
        yield ErrorRequestOtpChangeContact(e.toString(),
            placeOrder: state.placeOrder);
      }
    }
  }

  Stream<FoodOrderState> mapMarkRestaurantHasShownBusyDialogToState(
      String restaurantId) async* {
    PlaceOrder placeOrder = state.placeOrder;
    if (!(placeOrder.shownBusyDialogRestaurantIds.contains(restaurantId))) {
      placeOrder.shownBusyDialogRestaurantIds.add(restaurantId);
    }

    yield FoodOrderState(placeOrder: placeOrder);
  }

  Stream<FoodOrderState> mapInitCashfreePaymentToState() async* {
    yield LoadingPlaceOrder(placeOrder: state.placeOrder);
    try {
      Map<String, String> result = await repository.initCashfreePayment(
          state.placeOrder.user.token,
          state.placeOrder.getTotal().toString(),
          state.placeOrder.restaurant.currencyCode);

      Map<String, dynamic> inputParams = {
        "orderId": result['order_id'],
        "orderAmount": state.placeOrder.getTotal().toString(),
        "customerName": state.placeOrder.user.name,
        "orderCurrency": state.placeOrder.restaurant.currencyCode,
        "appId": result['app_id'],
        "tokenData": result['token'],
        "customerPhone": state.placeOrder.user.phone,
        "customerEmail": state.placeOrder.user.username,
        //"stage": "TEST"
        "stage": "PROD"
      };

      Map<dynamic, dynamic> map = await CashfreePGSDK.doPayment(inputParams);

      if (map['txStatus'] == 'SUCCESS') {
        add(ChangePaymentReference(map['referenceId']));
        add(PlaceOrderEvent());
      } else if (map['txStatus'] == 'CANCELLED') {
        yield CancelledPlaceOrder("Order Cancelled",
            placeOrder: state.placeOrder);
      } else {
        yield ErrorPlaceOrder("Payment Fail. Please try another payment method",
            placeOrder: state.placeOrder);
      }
    } catch (e) {
      yield CashFreePaymentFail(e.toString(), placeOrder: state.placeOrder);
    }
  }
}
