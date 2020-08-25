import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/scratch_card.dart';
import 'package:intl/intl.dart';

import './bloc.dart';

class ScratchCardListBloc
    extends Bloc<ScratchCardListEvent, ScratchCardListState> {
  DataRepository repository = DataRepository();

  @override
  ScratchCardListState get initialState => LoadingList();

  @override
  Stream<ScratchCardListState> mapEventToState(
    ScratchCardListEvent event,
  ) async* {
    if (event is GetScratchCardList) {
      yield* mapGetScratchCardListToSTate(event.token);
    } else if (event is DoScratchCard) {
      yield* mapDoScratchCardToState(event.token, event.cardId, event.pos);
    }
  }

  Stream<ScratchCardListState> mapGetScratchCardListToSTate(
      String token) async* {
    yield LoadingList(
        scratchAmountTotal: state.scratchAmountTotal,
        scratchList: state.scratchList);
    try {
      Map<String, dynamic> map = await repository.getScratchCardList(token);
      if (map['list'] != null) {
        yield ScratchCardListState(
            scratchAmountTotal: double.parse(map['amount']),
            currencyCode: map['currency_code'],
            scratchList: map['list']);
      } else {
        yield NoAvailableList();
      }
    } catch (e) {
      yield ErrorList(e.toString());
    }
  }

  Stream<ScratchCardListState> mapDoScratchCardToState(
      String token, String cardId, int pos) async* {
    try {
      bool result = await repository.scratchCard(token, cardId);

      if (result) {
        /*ScratchCard sc =
            state.scratchList.singleWhere((element) => cardId == element.cardId).copyWith(isScratched: true);
        int pos = state.scratchList.indexWhere((element) => cardId == element.cardId);
        List<ScratchCard> list = state.scratchList;
        list[pos] = sc;*/

        ScratchCard sc = state.scratchList[pos].copyWith(
            isScratched: true,
            dateScratched: DateFormat('yyyy-mm-dd').format(DateTime.now()));
        List<ScratchCard> list = state.scratchList;
        list[pos] = sc;

        double newAmount = state.scratchAmountTotal + sc.amount;

        yield ScratchCardListState(
            scratchList: list,
            scratchAmountTotal: newAmount,
            currencyCode: state.currencyCode);
      } else {
        yield ErrorScratch("Error scratch the card",
            scratchList: state.scratchList,
            scratchAmountTotal: state.scratchAmountTotal,
            currency: state.currencyCode);
      }
    } catch (e) {
      yield ErrorScratch(e.toString(),
          scratchList: state.scratchList,
          scratchAmountTotal: state.scratchAmountTotal,
          currency: state.currencyCode);
    }
  }
}
