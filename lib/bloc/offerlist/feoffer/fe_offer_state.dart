import 'package:clients/model/fe_offer.dart';

class FeOfferState {
  final List<FEOffer> feOffers;

  FeOfferState({this.feOffers});
}

class LoadingFEOfferState extends FeOfferState {}

class ErrorFEOfferState extends FeOfferState {
  final String message;

  ErrorFEOfferState(this.message);
}
