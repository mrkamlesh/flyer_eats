import 'package:clients/model/location.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetHomeDataByLocation extends HomeEvent {
  final Location location;
  final String token;

  const GetHomeDataByLocation(this.location, this.token);

  @override
  List<Object> get props => [location, token];
}

class GetHomeDataByLatLng extends HomeEvent {
  final double lat;
  final double lng;
  final String token;

  const GetHomeDataByLatLng(this.token, this.lat, this.lng);

  @override
  List<Object> get props => [token, lat, lng];
}

class InitGetData extends HomeEvent {
  final String token;
  final Location location;
  final String lastSavedLocation;

  InitGetData(this.token, this.location, this.lastSavedLocation);

  @override
  List<Object> get props => [];
}

class LoadMoreTopRestaurant extends HomeEvent {
  final String token;
  final Location location;

  LoadMoreTopRestaurant(this.token, this.location);

  @override
  List<Object> get props => [];
}

class LoadMoreDblRestaurant extends HomeEvent {
  final String token;
  final Location location;

  LoadMoreDblRestaurant(this.token, this.location);

  @override
  List<Object> get props => [];
}
