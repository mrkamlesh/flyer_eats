import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/fe_offer.dart';
import './bloc.dart';

class FeOfferBloc extends Bloc<FeOfferEvent, FeOfferState> {
  DataRepository repository = DataRepository();

  @override
  FeOfferState get initialState => LoadingFEOfferState();

  @override
  Stream<FeOfferState> mapEventToState(
    FeOfferEvent event,
  ) async* {
    if (event is GetFEOffer) {
      yield* mapGetFEOfferToState(event.token, event.address);
    }
  }

  Stream<FeOfferState> mapGetFEOfferToState(String token, String address) async* {
    if (state.feOffers == null) {
      yield LoadingFEOfferState();
      try {
        List<FEOffer> list = await repository.getFEOfferList(token, address);
        yield FeOfferState(feOffers: list);
      } catch (e) {
        yield ErrorFEOfferState(e.toString());
      }
    }
  }
}
