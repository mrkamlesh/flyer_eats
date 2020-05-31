import 'package:equatable/equatable.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RestaurantTopState extends Equatable {
  const RestaurantTopState();
}

class LoadingRestaurantTop extends RestaurantTopState {

  const LoadingRestaurantTop();

  @override
  List<Object> get props => [];
}

class SuccessRestaurantTop extends RestaurantTopState {
  final List<Restaurant> restaurants;

  const SuccessRestaurantTop(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class ErrorRestaurantTop extends RestaurantTopState {
  final String message;

  ErrorRestaurantTop(this.message);

  @override
  List<Object> get props => [message];
}

class InitialRestaurantTopState extends RestaurantTopState {
  const InitialRestaurantTopState();

  @override
  List<Object> get props => [];
}

class NoRestaurantTopAvaliable extends RestaurantTopState {
  const NoRestaurantTopAvaliable();

  @override
  List<Object> get props => [];
}
