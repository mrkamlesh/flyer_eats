import 'package:equatable/equatable.dart';
import 'package:flyereats/model/home_page_data.dart';
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
  final List<Location> locations;

  const LoadingPredefinedLocationsSuccess(this.locations);

  @override
  List<Object> get props => [locations];
}

class LoadingPredefinedLocationsError extends LocationState {
  final String message;

  const LoadingPredefinedLocationsError(this.message);

  @override
  List<Object> get props => [message];
}

class HomePageDataLoaded extends LocationState {
  final HomePageData data;

  const HomePageDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class NoLocationsAvailable extends LocationState {

  final String message;

  const NoLocationsAvailable({this.message = "We are not available yet in your location"});

  @override
  List<Object> get props => [];
}

class PredefinedLocationsFiltered extends LocationState {

  final List<Location> locations;

  const PredefinedLocationsFiltered(this.locations);

  @override
  List<Object> get props => [locations];
}