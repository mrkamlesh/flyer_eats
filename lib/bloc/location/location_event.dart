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
  final LatLng latLng;

  const GetPredefinedLocations(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class SelectLocation extends LocationEvent {
  final Location location;

  const SelectLocation(this.location);

  @override
  List<Object> get props => [location];
}

