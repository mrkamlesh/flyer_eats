import 'package:flyereats/model/scratch_card.dart';

class ScratchCardListState {
  final double scratchAmountTotal;
  final String currency;
  final List<ScratchCard> scratchList;

  ScratchCardListState({this.scratchAmountTotal, this.scratchList, this.currency});
}

class LoadingList extends ScratchCardListState {
  LoadingList({double scratchAmountTotal, String currency, List<ScratchCard> scratchList})
      : super(scratchAmountTotal: scratchAmountTotal, currency: currency, scratchList: scratchList);
}

class NoAvailableList extends ScratchCardListState {
  NoAvailableList() : super();
}

class ErrorList extends ScratchCardListState {
  final String message;

  ErrorList(this.message) : super();
}

class ErrorScratch extends ScratchCardListState {
  final String message;

  ErrorScratch(this.message, {double scratchAmountTotal, String currency, List<ScratchCard> scratchList})
      : super(scratchAmountTotal: scratchAmountTotal, currency: currency, scratchList: scratchList);
}
