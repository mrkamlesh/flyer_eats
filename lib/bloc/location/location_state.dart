import 'package:equatable/equatable.dart';
import 'package:flyereats/model/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationState extends Equatable {
  const LocationState();
}

class InitialLocationState extends LocationState {
  @override
  List<Object> get props => [];
}

class LoadingLocation extends LocationState {
  const LoadingLocation();

  @override
  List<Object> get props => [];
}

class LoadingLocationSuccess extends LocationState {
  final Location location;

  const LoadingLocationSuccess(this.location);

  @override
  List<Object> get props => [location];
}

class LoadingLocationError extends LocationState {
  final String message;

  const LoadingLocationError(this.message);

  @override
  List<Object> get props => [message];
}

class UpdatingLocation extends LocationState {
  const UpdatingLocation();

  @override
  List<Object> get props => [];
}

class UpdatingLocationSuccess extends LocationState {
  final Location location;

  const UpdatingLocationSuccess(this.location);

  @override
  List<Object> get props => [location];
}

class UpdatingLocationError extends LocationState {
  final String message;

  const UpdatingLocationError(this.message);

  @override
  List<Object> get props => [message];
}

class LocationMoved extends LocationState {
  final LatLng latLng;

  const LocationMoved(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class LoadingPredefinedLocations extends LocationState {
  const LoadingPredefinedLocations();

  @override
  List<Object> get props => [];
}

class LoadingPredefinedLocationsSuccess extends LocationState {
  final List<Location> location;

  const LoadingPredefinedLocationsSuccess(this.location);

  @override
  List<Object> get props => [location];
}

class LoadingPredefinedLocationsError extends LocationState {
  final String message;

  const LoadingPredefinedLocationsError(this.message);

  @override
  List<Object> get props => [message];
}

class LocationSelected extends LocationState {
  final Location location;

  const LocationSelected(this.location);

  @override
  List<Object> get props => [location];
}

class NoLocationsAvailable extends LocationState {
  const NoLocationsAvailable();

  @override
  List<Object> get props => [];
}