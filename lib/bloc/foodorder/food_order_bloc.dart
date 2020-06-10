import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/model/address.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/food_cart.dart';
import 'package:flyereats/model/place_order.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/user.dart';
import './bloc.dart';

class FoodOrderBloc extends Bloc<FoodOrderEvent, FoodOrderState> {
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
      yield* mapChangeAddress(event.address);
    } else if (event is ChangeContactPhone) {
      yield* mapChangeContacPhone(event.contact);
    } else if (event is ChangeQuantityFoodCart) {
      yield* mapChangeQuantityFoodCart(event.id, event.food, event.quantity);
    }
  }

  Stream<FoodOrderState> mapChangeTransactionTypeToState(
      String transactionType) async* {
    yield FoodOrderState(
        placeOrder:
            state.placeOrder.copyWith(transactionType: transactionType));
  }

  Stream<FoodOrderState> mapChangeAddress(Address address) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(address: address));
  }

  Stream<FoodOrderState> mapChangeContacPhone(String contact) async* {
    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(contact: contact));
  }

  Stream<FoodOrderState> mapChangeQuantityFoodCart(
      String id, Food food, int quantity) async* {
    FoodCart newCart = state.placeOrder.foodCart;
    newCart.changeQuantity(id, food, quantity);

    yield FoodOrderState(
        placeOrder: state.placeOrder.copyWith(foodCart: newCart));
  }

  Stream<FoodOrderState> mapInitPlaceOrderToState(
      Restaurant restaurant, FoodCart foodCart, User user) async* {
    yield FoodOrderState(
      placeOrder: PlaceOrder(
        restaurant: restaurant,
        foodCart: foodCart,
        user: user,
        address: user.defaultAddress,
        contact: user.phone,
        transactionType: 'delivery',
      ),
    );
  }
}
