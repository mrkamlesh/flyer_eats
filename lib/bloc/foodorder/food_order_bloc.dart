import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/foodorder/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/place_order.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';
import 'package:flyereats/model/voucher.dart';

class FoodOrderBloc extends Bloc<FoodOrderEvent, FoodOrderState> {
  DataRepository repository = DataRepository();

  @override
  FoodOrderState get initialState => InitialFoodOrderState();

  @override
  Stream<FoodOrderState> mapEventToState(
    FoodOrderEvent event,
  ) async* {
    if (event is InitPlaceOrder) {
      yield* mapInitPlaceOrderToState(
          event.restaurant, event.foodCart, event.user);
    } else if (event is ChangeTransactionType) {
      yield* mapChangeTransactionTypeToState(event.transactionType);
    } else if (event is ChangeAddress) {
      yield* mapChangeAddressToState(event.address);
    } else if (event is ChangeContactPhone) {
      yield* mapChangeContactPhoneToState(event.contact);
    } else if (event is ChangeQuantityFoodCart) {
      yield* mapChangeQuantityFoodCartToState(
          event.id, event.food, event.quantity);
    } else if (event is ChangeInstruction) {
      yield* mapChangeInstructionToState(event.instruction);
    } else if (event is GetPaymentOptions) {
      yield* mapGetPaymentOptionsToState(event.order);
    } else if (event is ApplyVoucher) {
      yield* mapApplyCouponToState(event.voucher);
    } else if (event is ChangePaymentList) {
      yield* mapChangePaymentListToState(event.paymentList);
    } else if (event is PlaceOrderEvent) {
      yield* mapPlaceOrderEventToState();
    }
  }

  Stream<FoodOrderState> mapChangeTransactionTypeToState(
      String transactionType) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(transactionType: transactionType));
    add(GetPaymentOptions(state.placeOrder));
  }

  Stream<FoodOrderState> mapChangeAddressToState(Address address) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(address: address));
    add(GetPaymentOptions(state.placeOrder));
  }

  Stream<FoodOrderState> mapChangeContactPhoneToState(String contact) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(contact: contact));
  }

  Stream<FoodOrderState> mapChangeQuantityFoodCartToState(
      String id, Food food, int quantity) async* {
    FoodCart newCart = state.placeOrder.foodCart;
    newCart.changeQuantity(id, food, quantity);

    if (newCart.cart.length > 0) {
      yield FoodOrderState(
          placeOrder: state.placeOrder.copyWith(foodCart: newCart));
      add(GetPaymentOptions(state.placeOrder));
    } else {
      yield NoItemsInCart();
    }
  }

  Stream<FoodOrderState> mapInitPlaceOrderToState(
      Restaurant restaurant, FoodCart foodCart, User user) async* {
    yield FoodOrderState(
      placeOrder: PlaceOrder(
          isValid: true,
          restaurant: restaurant,
          foodCart: foodCart,
          user: user,
          address: user.defaultAddress,
          contact: user.phone,
          transactionType: 'delivery',
          deliveryInstruction: '',
          deliveryCharges: 0,
          voucher: Voucher(amount: 0),
          paymentList: "",
          discountOrder: 0,
          discountOrderPrettyString: "DISCOUNT ORDER",
          taxCharges: 0,
          packagingCharges: 0,
          taxPrettyString: "Tax"),
    );

    add(GetPaymentOptions(state.placeOrder));
  }

  Stream<FoodOrderState> mapChangeInstructionToState(
      String instruction) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(deliveryInstruction: instruction));
  }

  Stream<FoodOrderState> mapGetPaymentOptionsToState(PlaceOrder order) async* {
    yield LoadingGetPayments(
        placeOrder: state.placeOrder.copyWith(isValid: false));
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
                discountPrettyString: result.discountOrderPrettyString,
                deliveryCharges: result.deliveryCharges));
      } else {
        yield FoodOrderState(
            placeOrder: state.placeOrder
                .copyWith(isValid: false, message: result.message));
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

  Stream<FoodOrderState> mapChangePaymentListToState(
      String paymentList) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(paymentList: paymentList));

    add(PlaceOrderEvent());
  }

  Stream<FoodOrderState> mapPlaceOrderEventToState() async* {
    yield LoadingPlaceOrder(placeOrder: state.placeOrder);
    try {
      PlaceOrder placeOrder = await repository.placeOrder(state.placeOrder);

      if (placeOrder.id != null) {
        yield SuccessPlaceOrder(
            placeOrder: state.placeOrder
                .copyWith(id: placeOrder.id, message: placeOrder.message));
      } else {
        ErrorPlaceOrder(placeOrder.message,
            placeOrder: state.placeOrder
                .copyWith(isValid: false, message: placeOrder.message));
      }
    } catch (e) {
      yield ErrorPlaceOrder(e.toString(),
          placeOrder: state.placeOrder.copyWith());
    }
  }
}
