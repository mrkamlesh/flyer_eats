import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MerchantOfferEvent extends Equatable {
  const MerchantOfferEvent();
}

class GetMerchantOffer extends MerchantOfferEvent {
  final String token;
  final String address;

  GetMerchantOffer(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}
