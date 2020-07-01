import 'package:flyereats/model/ads.dart';

class PlacedOrderSuccessState {}

class LoadingAds extends PlacedOrderSuccessState {}

class SuccessAds extends PlacedOrderSuccessState {
  final List<Ads> ads;

  SuccessAds(this.ads);
}

class ErrorAds extends PlacedOrderSuccessState {
  final String message;

  ErrorAds(this.message);
}
