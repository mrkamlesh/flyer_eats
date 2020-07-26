import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/voucher.dart';

class FoodOrderBloc extends Bloc<FoodOrderEvent, FoodOrderState> {
  DataRepository repository = DataRepository();

  @override
  FoodOrderState get initialState => NoItemsInCart();

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
      yield* mapChangeContactPhoneToState(event.isChangePrimaryContact, event.contact);
    } else if (event is ChangeQuantityWithPayment) {
      yield* mapChangeQuantityWithPaymentToState(event.id, event.food, event.quantity, event.selectedPrice);
    } else if (event is ChangeQuantityNoPayment) {
      yield* mapChangeQuantityNoPaymentToState(
          event.restaurant, event.id, event.food, event.quantity, event.selectedPrice);
    } else if (event is ChangeInstruction) {
      yield* mapChangeInstructionToState(event.instruction);
    } else if (event is GetPaymentOptions) {
      yield* mapGetPaymentOptionsToState(event.order);
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
    }
  }

  Stream<FoodOrderState> mapChangeTransactionTypeToState(String transactionType) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(transactionType: transactionType));
    add(GetPaymentOptions(state.placeOrder));
  }

  Stream<FoodOrderState> mapChangeAddressToState(Address address) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(address: address));
    add(GetPaymentOptions(state.placeOrder));
  }

  Stream<FoodOrderState> mapChangeContactPhoneToState(bool isChangePrimaryContact, String contact) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(contact: contact, isChangePrimaryContact: isChangePrimaryContact));
  }

  Stream<FoodOrderState> mapChangeQuantityWithPaymentToState(
      String id, Food food, int quantity, int selectedPrice) async* {
    FoodCart newCart = state.placeOrder.foodCart;
    newCart.changeQuantity(id, food, quantity, selectedPrice);

    if (newCart.cart.length > 0) {
      yield FoodOrderState(placeOrder: state.placeOrder.copyWith(foodCart: newCart));
      add(GetPaymentOptions(state.placeOrder));
    } else {
      yield NoItemsInCart();
    }
  }

  Stream<FoodOrderState> mapChangeQuantityNoPaymentToState(
      Restaurant selectedRestaurant, String id, Food food, int quantity, int selectedPrice) async* {
    yield FoodOrderState(placeOrder: state.placeOrder);

    if (selectedRestaurant.id == state.placeOrder.restaurant.id || state.placeOrder.restaurant.id == null) {
      FoodCart newCart = state.placeOrder.foodCart;
      newCart.changeQuantity(id, food, quantity, selectedPrice);

      if (newCart.cart.length > 0) {
        yield CartChangeState(placeOrder: state.placeOrder.copyWith(foodCart: newCart, restaurant: selectedRestaurant));
      } else {
        yield NoItemsInCart();
      }
    } else {
      yield ConfirmCartState(selectedRestaurant, id, food, quantity, selectedPrice, placeOrder: state.placeOrder);
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
            contact: user.phone,
            transactionType: 'delivery',
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
            now: now,
            selectedDeliveryTime: now.add(Duration(minutes: 45))),
      );

      add(GetPaymentOptions(state.placeOrder));
    }
  }

  Stream<FoodOrderState> mapChangeInstructionToState(String instruction) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(deliveryInstruction: instruction));
  }

  Stream<FoodOrderState> mapGetPaymentOptionsToState(PlaceOrder order) async* {
    yield LoadingGetPayments(placeOrder: state.placeOrder.copyWith(isValid: false));
    try {
      PlaceOrder result = await repository.getPaymentOptions(state.placeOrder);

      if (result.isValid) {
        yield FoodOrderState(
            placeOrder: state.placeOrder.copyWith(
                isValid: true,
                message: result.message,
                razorKey: result.razorKey,
                razorSecret: result.razorSecret,
                taxCharges: result.taxCharges,
                packagingCharges: result.packagingCharges,
                taxPrettyString: result.taxPrettyString,
                discountOrder: result.discountOrder,
                discountOrderPrettyString: result.discountOrderPrettyString,
                deliveryCharges: result.deliveryCharges,
                walletAmount: result.walletAmount,
                listPaymentMethod: result.listPaymentMethod));
      } else {
        yield FoodOrderState(placeOrder: state.placeOrder.copyWith(isValid: false, message: result.message));
      }
    } catch (e) {
      yield FoodOrderState(placeOrder: state.placeOrder.copyWith(isValid: false, message: e.toString()));
    }
  }

  Stream<FoodOrderState> mapApplyCouponToState(Voucher voucher) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(voucher: voucher));
  }

  Stream<FoodOrderState> mapChangePaymentMethodToState(String paymentMethod) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(selectedPaymentMethod: paymentMethod));
  }

  Stream<FoodOrderState> mapPlaceOrderEventToState() async* {
    yield LoadingPlaceOrder(placeOrder: state.placeOrder);
    try {
      PlaceOrder placeOrder = await repository.placeOrder(state.placeOrder);

      //PlaceOrder placeOrder = PlaceOrder(id: "55919");

      if (placeOrder.id != null) {
        yield SuccessPlaceOrder(placeOrder: state.placeOrder.copyWith(id: placeOrder.id, message: placeOrder.message));
      } else {
        yield ErrorPlaceOrder(placeOrder.message,
            placeOrder: state.placeOrder.copyWith(isValid: false, message: placeOrder.message));
      }
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(), placeOrder: state.placeOrder.copyWith());
    }
  }

  Stream<FoodOrderState> mapChangeWalletUsageToState(bool isUseWallet) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(isUseWallet: isUseWallet));
  }

  Stream<FoodOrderState> mapChangeDeliveryTimeToState(DateTime dateTime) async* {
    yield FoodOrderState(placeOrder: state.placeOrder.copyWith(selectedDeliveryTime: dateTime));
  }

  Stream<FoodOrderState> mapClearCartToState() async* {
    yield NoItemsInCart();
  }
}
