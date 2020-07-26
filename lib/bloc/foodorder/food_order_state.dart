import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/restaurant.dart';

class FoodOrderState {
  final PlaceOrder placeOrder;

  FoodOrderState({this.placeOrder});
}

class InitialFoodOrderState extends FoodOrderState {
  InitialFoodOrderState({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class LoadingGetPayments extends FoodOrderState {
  LoadingGetPayments({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

/*class ErrorGetPayments extends FoodOrderState {
  final String message;

  ErrorGetPayments(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}*/

class NoItemsInCart extends FoodOrderState {
  NoItemsInCart()
      : super(
            placeOrder: PlaceOrder(
                restaurant: Restaurant(null, null, null, null, null, null, null, false),
                foodCart: FoodCart(
                  Map(),
                )));
}

class LoadingPlaceOrder extends FoodOrderState {
  LoadingPlaceOrder({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class SuccessPlaceOrder extends FoodOrderState {
  SuccessPlaceOrder({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class CartChangeState extends FoodOrderState {
  CartChangeState({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class ErrorPlaceOrder extends FoodOrderState {
  final String message;

  ErrorPlaceOrder(this.message, {PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class ConfirmCartState extends FoodOrderState {
  final Restaurant tempSelectedRestaurant;
  final String tempId;
  final Food tempFood;
  final int tempQuantity;
  final int tempSelectedPrice;

  ConfirmCartState(this.tempSelectedRestaurant, this.tempId, this.tempFood, this.tempQuantity, this.tempSelectedPrice,
      {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}
