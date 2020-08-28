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
