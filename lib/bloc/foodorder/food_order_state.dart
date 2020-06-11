import 'package:flyereats/model/place_order.dart';

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
