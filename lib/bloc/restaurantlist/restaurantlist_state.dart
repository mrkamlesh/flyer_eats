import 'package:equatable/equatable.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantListState extends Equatable {
  const RestaurantListState();
}

class LoadingRestaurantList extends RestaurantListState {

  const LoadingRestaurantList();

  @override
  List<Object> get props => [];
}

class SuccessRestaurantList extends RestaurantListState {
  final List<Restaurant> restaurants;

  const SuccessRestaurantList(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class ErrorRestaurantList extends RestaurantListState {
  final String message;

  ErrorRestaurantList(this.message);

  @override
  List<Object> get props => [message];
}

class InitialRestaurantListState extends RestaurantListState {
  const InitialRestaurantListState();

  @override
  List<Object> get props => [];
}

class NoRestaurantListAvaliable extends RestaurantListState {
  const NoRestaurantListAvaliable();

  @override
  List<Object> get props => [];
}
