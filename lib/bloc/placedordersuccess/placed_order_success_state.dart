import 'package:clients/model/ads.dart';

class PlacedOrderSuccessState {}

class LoadingAds extends PlacedOrderSuccessState {}

class SuccessAds extends PlacedOrderSuccessState {
  final List<Ads> ads;
  final String referralCode;
  final String referralAmount;

  SuccessAds(this.ads, this.referralCode, this.referralAmount);
}

class ErrorAds extends PlacedOrderSuccessState {
  final String message;

  ErrorAds(this.message);
}
