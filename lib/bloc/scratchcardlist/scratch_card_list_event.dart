import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScratchCardListEvent extends Equatable {
  const ScratchCardListEvent();
}

class GetScratchCardList extends ScratchCardListEvent {
  final String token;

  GetScratchCardList(this.token);

  @override
  List<Object> get props => [token];
}

class DoScratchCard extends ScratchCardListEvent {
  final String token;
  final String cardId;
  final int pos;

  DoScratchCard(this.token, this.cardId, this.pos);

  @override
  List<Object> get props => [token, cardId, pos];
}
