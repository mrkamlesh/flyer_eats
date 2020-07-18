import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/bank.dart';
import './bloc.dart';

class BankOfferBloc extends Bloc<BankOfferEvent, BankOfferState> {
  DataRepository repository = DataRepository();

  @override
  BankOfferState get initialState => LoadingBankOfferState();

  @override
  Stream<BankOfferState> mapEventToState(
    BankOfferEvent event,
  ) async* {
    if (event is GetBankOffer) {
      yield* mapGetBankOfferToState(event.token, event.address);
    }
  }

  Stream<BankOfferState> mapGetBankOfferToState(String token, String address) async* {
    if (state.banks == null) {
      yield LoadingBankOfferState();
      try {
        List<Bank> list = await repository.getBankOfferList(token, address);
        yield BankOfferState(banks: list);
      } catch (e) {
        yield ErrorBankOfferState(e.toString());
      }
    }
  }
}
