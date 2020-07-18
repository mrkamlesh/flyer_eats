import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/restaurant.dart';
import './bloc.dart';

class MerchantOfferBloc extends Bloc<MerchantOfferEvent, MerchantOfferState> {
  DataRepository repository = DataRepository();

  @override
  MerchantOfferState get initialState => LoadingMerchantOfferState();

  @override
  Stream<MerchantOfferState> mapEventToState(
    MerchantOfferEvent event,
  ) async* {
    if (event is GetMerchantOffer) {
      yield* mapGetMerchantOfferToState(event.token, event.address);
    }
  }

  Stream<MerchantOfferState> mapGetMerchantOfferToState(String token, String address) async* {
    if (state.merchants == null) {
      yield LoadingMerchantOfferState();
      try {
        List<Restaurant> list = await repository.getMerchantOfferList(token, address);
        yield MerchantOfferState(merchants: list);
      } catch (e) {
        yield ErrorMerchantOfferState(e.toString());
      }
    }
  }
}
