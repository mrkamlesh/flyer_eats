import 'package:clients/model/ads.dart';
import 'package:clients/model/restaurant.dart';

class CancelledOrderState {}

class InitialCancelledOrderState extends CancelledOrderState {}

class LoadingAds extends CancelledOrderState {}

class SuccessAds extends CancelledOrderState {
  final List<Ads> ads;

  SuccessAds(this.ads);
}

class ErrorAds extends CancelledOrderState {
  final String message;

  ErrorAds(this.message);
}

class LoadingSimilarRestaurant extends CancelledOrderState {}

class SuccessSimilarRestaurant extends CancelledOrderState {
  final String categoryId;
  final List<Restaurant> restaurants;

  SuccessSimilarRestaurant(this.restaurants, this.categoryId);
}

class ErrorSimilarRestaurant extends CancelledOrderState {
  final String message;

  ErrorSimilarRestaurant(this.message);
}
