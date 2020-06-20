import 'package:equatable/equatable.dart';
import 'package:flyereats/model/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class InitDefaultAddress extends LocationEvent {
  const InitDefaultAddress();

  @override
  List<Object> get props => [];
}

class GetCurrentLocation extends LocationEvent {
  final String token;

  const GetCurrentLocation(this.token);

  @override
  List<Object> get props => [token];
}

class UpdateLocation extends LocationEvent {
  final LatLng latLng;

  const UpdateLocation(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class MoveLocation extends LocationEvent {
  final LatLng latLng;

  const MoveLocation(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class GetPredefinedLocations extends LocationEvent {
  final String countryId;

  const GetPredefinedLocations(this.countryId);

  @override
  List<Object> get props => [countryId];
}

class GetHomeDataByLocation extends LocationEvent {
  final Location location;

  final String token;

  const GetHomeDataByLocation(this.location, this.token);

  @override
  List<Object> get props => [location, token];
}

class FilterLocations extends LocationEvent {
  final String filter;

  const FilterLocations(this.filter);

  @override
  List<Object> get props => [filter];
}

class GetPreviousLocation extends LocationEvent {
  const GetPreviousLocation();

  @override
  List<Object> get props => [];
}

class GetHomeDataByLatLng extends LocationEvent {
  final double lat;
  final double lng;
  final String token;

  const GetHomeDataByLatLng(this.token, this.lat, this.lng);

  @override
  List<Object> get props => [token, lat, lng];
}
