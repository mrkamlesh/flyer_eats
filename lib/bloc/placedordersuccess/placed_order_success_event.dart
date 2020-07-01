import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PlacedOrderSuccessEvent extends Equatable {
  const PlacedOrderSuccessEvent();
}

class GetAds extends PlacedOrderSuccessEvent {
  final String token;
  final String address;

  GetAds(this.token, this.address);

  @override
  List<Object> get props => [token, address];
}
