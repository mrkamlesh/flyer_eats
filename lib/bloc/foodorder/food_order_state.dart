import 'package:clients/model/place_order.dart';

class FoodOrderState {
  final PlaceOrder placeOrder;

  FoodOrderState({this.placeOrder});
}

class InitialFoodOrderState extends FoodOrderState {
  InitialFoodOrderState() : super();
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
  NoItemsInCart() : super();
}

class LoadingPlaceOrder extends FoodOrderState {
  LoadingPlaceOrder({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class SuccessPlaceOrder extends FoodOrderState {
  SuccessPlaceOrder({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class ErrorPlaceOrder extends FoodOrderState {
  final String message;

  ErrorPlaceOrder(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}
