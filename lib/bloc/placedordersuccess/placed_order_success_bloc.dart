import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import './bloc.dart';

class PlacedOrderSuccessBloc extends Bloc<PlacedOrderSuccessEvent, PlacedOrderSuccessState> {
  DataRepository repository = DataRepository();

  @override
  PlacedOrderSuccessState get initialState => LoadingAds();

  @override
  Stream<PlacedOrderSuccessState> mapEventToState(
    PlacedOrderSuccessEvent event,
  ) async* {
    if (event is GetAds) {
      yield* mapGetAdsToState(event.token, event.address);
    }
  }

  Stream<PlacedOrderSuccessState> mapGetAdsToState(String token, String address) async* {
    yield LoadingAds();

    try {
      var result = await repository.getAds(token, address);
      if (result is List) {
        yield SuccessAds(result);
      } else {
        yield ErrorAds("Error get Ads");
      }
    } catch (e) {
      yield ErrorAds(e.toString());
    }
  }
}
