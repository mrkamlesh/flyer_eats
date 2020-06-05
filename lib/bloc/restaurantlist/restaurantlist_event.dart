import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantListEvent extends Equatable {
  const RestaurantListEvent();
}

class GetFirstDataRestaurantList extends RestaurantListEvent {

  final String address;

  const GetFirstDataRestaurantList(this.address);

  @override
  List<Object> get props => [address];
}

class LoadMore extends RestaurantListEvent {
  final String address;

  const LoadMore(this.address);

  @override
  List<Object> get props => [address];
}