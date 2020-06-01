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
  final LocationEvent followedBy;

  const GetCurrentLocation({this.followedBy});

  @override
  List<Object> get props => [followedBy];
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

class SelectLocation extends LocationEvent {
  final Location location;

  const SelectLocation(this.location);

  @override
  List<Object> get props => [location];
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

class GetLocationByLatLng extends LocationEvent {
  final double lat;
  final double lng;

  const GetLocationByLatLng(this.lat, this.lng);

  @override
  List<Object> get props => [lat, lng];
}
