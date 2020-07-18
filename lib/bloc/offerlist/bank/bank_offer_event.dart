import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BankOfferEvent extends Equatable {
  const BankOfferEvent();
}

class GetBankOffer extends BankOfferEvent {
  final String token;
  final String address;

  GetBankOffer(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}
