import 'package:clients/model/add_on.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_cart.dart';
import 'package:clients/model/food_detail.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/price.dart';
import 'package:clients/model/restaurant.dart';

class FoodOrderState {
  final PlaceOrder placeOrder;

  FoodOrderState({this.placeOrder});
}

class InitialFoodOrderState extends FoodOrderState {
  InitialFoodOrderState({PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
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
  NoItemsInCart({List<String> shownBusyDialogRestaurantIds})
      : super(
            placeOrder: PlaceOrder(
                restaurant: Restaurant(
                    null, null, null, null, null, null, null, false, null),
                foodCart: FoodCart(Map(), List()),
                shownBusyDialogRestaurantIds: shownBusyDialogRestaurantIds));
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

  ErrorPlaceOrder(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class CancelledPlaceOrder extends FoodOrderState {
  final String message;

  CancelledPlaceOrder(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class ConfirmCartState extends FoodOrderState {
  final Restaurant tempSelectedRestaurant;
  final String tempId;
  final Food tempFood;
  final int tempQuantity;
  final Price tempPrice;
  final List<AddOn> tempAddOns;

  ConfirmCartState(this.tempSelectedRestaurant, this.tempId, this.tempFood,
      this.tempQuantity, this.tempPrice, this.tempAddOns,
      {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class LoadingGetFoodDetail extends FoodOrderState {
  LoadingGetFoodDetail({PlaceOrder placeOrder}) : super(placeOrder: placeOrder);
}

class SuccessGetFoodDetail extends FoodOrderState {
  final FoodDetail foodDetail;

  SuccessGetFoodDetail(this.foodDetail, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class ErrorGetFoodDetail extends FoodOrderState {
  final String message;

  ErrorGetFoodDetail(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class LoadingRequestOtpChangeContact extends FoodOrderState {
  LoadingRequestOtpChangeContact({PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class SuccessRequestOtpChangeContact extends FoodOrderState {
  final String newContact;
  final bool isChangePrimaryContact;

  SuccessRequestOtpChangeContact(this.newContact, this.isChangePrimaryContact,
      {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}

class ErrorRequestOtpChangeContact extends FoodOrderState {
  final String message;

  ErrorRequestOtpChangeContact(this.message, {PlaceOrder placeOrder})
      : super(placeOrder: placeOrder);
}
