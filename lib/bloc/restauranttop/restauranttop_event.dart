import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantTopEvent extends Equatable {
  const RestaurantTopEvent();
}

class GetRestaurantTop extends RestaurantTopEvent {

  final String address;

  const GetRestaurantTop(this.address);

  @override
  List<Object> get props => [address];
}