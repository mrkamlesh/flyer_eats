import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/ads.dart';
import './bloc.dart';

class CancelledOrderBloc extends Bloc<CancelledOrderEvent, CancelledOrderState> {
  DataRepository repository = DataRepository();

  @override
  CancelledOrderState get initialState => InitialCancelledOrderState();

  @override
  Stream<CancelledOrderState> mapEventToState(
    CancelledOrderEvent event,
  ) async* {
    if (event is GetAds) {
      yield* mapGetAdsToState(event.token, event.address);
    } else if (event is GetSimilarRestaurant) {
      yield* mapGetSimilarRestaurantToState(event.token, event.address, event.merchantId);
    }
  }

  Stream<CancelledOrderState> mapGetAdsToState(String token, String address) async* {
    yield LoadingAds();
    try {
      var result = await repository.getAds(token, address);
      if (result is List<Ads>) {
        yield SuccessAds(result);
      } else {
        yield ErrorAds("Error get Ads");
      }
    } catch (e) {
      yield ErrorAds(e.toString());
    }
  }

  Stream<CancelledOrderState> mapGetSimilarRestaurantToState(String token, String address, String merchantId) async* {
    add(GetAds(token, address));
    yield LoadingSimilarRestaurant();
    try {
      var result = await repository.getSimilarRestaurant(token, address, merchantId);
      if (result is Map) {
        yield SuccessSimilarRestaurant(result['restaurants'], result['category']);
      } else {
        yield ErrorSimilarRestaurant(result as String);
      }
    } catch (e) {
      yield ErrorSimilarRestaurant(e.toString());
    }
  }
}
