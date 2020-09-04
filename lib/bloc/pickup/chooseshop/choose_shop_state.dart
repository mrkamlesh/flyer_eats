import 'package:clients/model/shop.dart';

class ChooseShopState {
  final Shop shop;

  ChooseShopState({this.shop});
}

class InitialState extends ChooseShopState {
  InitialState() : super(shop: Shop());
}

class LoadingState extends ChooseShopState {
  LoadingState({Shop shop}) : super(shop: shop);
}

class ErrorState extends ChooseShopState {
  final String message;

  ErrorState(this.message, {Shop shop}) : super(shop: shop);
}

class SuccessGetCurrentLocation extends ChooseShopState {
  final double lat;
  final double lng;

  SuccessGetCurrentLocation(this.lat, this.lng, {Shop shop})
      : super(shop: shop);
}
