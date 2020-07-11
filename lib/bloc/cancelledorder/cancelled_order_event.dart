import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CancelledOrderEvent extends Equatable {
  const CancelledOrderEvent();
}

class GetAds extends CancelledOrderEvent {
  final String token;
  final String address;

  GetAds(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}

class GetSimilarRestaurant extends CancelledOrderEvent {
  final String token;
  final String address;
  final String merchantId;

  GetSimilarRestaurant(this.token, this.address, this.merchantId);

  @override
  List<Object> get props => [token, address, merchantId];
}
