import 'package:clients/model/restaurant.dart';

class MerchantOfferState {
  final List<Restaurant> merchants;

  MerchantOfferState({this.merchants});
}

class LoadingMerchantOfferState extends MerchantOfferState {}

class ErrorMerchantOfferState extends MerchantOfferState {
  final String message;

  ErrorMerchantOfferState(this.message);
}
