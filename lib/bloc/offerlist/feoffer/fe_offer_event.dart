import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FeOfferEvent extends Equatable {
  const FeOfferEvent();
}

class GetFEOffer extends FeOfferEvent {
  final String token;
  final String address;

  GetFEOffer(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}
