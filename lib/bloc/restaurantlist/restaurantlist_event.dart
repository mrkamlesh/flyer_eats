import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();
}

class GetRestaurantList extends RestaurantListEvent {

  final String address;

  const GetRestaurantList(this.address);

  @override
  List<Object> get props => [address];
}