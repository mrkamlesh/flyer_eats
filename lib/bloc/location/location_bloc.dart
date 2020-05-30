import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/classes/data_repository.dart';
import 'package:flyereats/model/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  DataRepository repository = DataRepository();
  List<Location> savedPredefinedLocations = List();
  Location selectedLocation = Location();

  @override
  LocationState get initialState => InitialLocationState();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is GetCurrentLocation) {
      yield* mapGetCurrentLocationToState(event.followedBy);
    } else if (event is UpdateLocation) {
      yield* mapUpdateLocationToState(event.latLng);
    } else if (event is MoveLocation) {
      yield* mapMoveLocationToState(event.latLng);
    } else if (event is GetPredefinedLocations) {
      yield* mapGetPredefinedLocationsToState(event.latLng);
    } else if (event is SelectLocation) {
      yield* mapSelectLocationToState(event.location);
    } else if (event is FilterLocations) {
      yield* mapFilterLocationsToState(event.filter);
    } else if (event is GetPreviousLocation) {
      yield* mapGetPreviousLocationToState();
    }
  }

  Stream<LocationState> mapGetCurrentLocationToState(
      LocationEvent followedBy) async* {
    yield LoadingLocation();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception();
      });

      yield LoadingLocationSuccess(Location(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      yield LoadingLocationError("Can not get location");
    }
  }

  Stream<LocationState> mapUpdateLocationToState(LatLng latLng) async* {
    yield UpdatingLocation();
    try {
      List<Placemark> placeMark = await Geolocator()
          .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      yield UpdatingLocationSuccess(Location(
          latitude: placeMark[0].position.latitude,
          longitude: placeMark[0].position.longitude,
          address: placeMark[0].name +
              " " +
              placeMark[0].locality +
              " " +
              placeMark[0].subAdministrativeArea +
              " " +
              placeMark[0].administrativeArea));
    } catch (e) {
      yield LoadingLocationError("Can not get location");
    }
  }

  Stream<LocationState> mapMoveLocationToState(LatLng latLng) async* {
    yield LocationMoved(latLng);
  }

  Stream<LocationState> mapGetPredefinedLocationsToState(LatLng latLng) async* {
    yield LoadingPredefinedLocations();
    try {
      List<Location> list =
          await repository.getLocations(latLng.latitude, latLng.longitude);
      if (list.length == 0) {
        yield NoLocationsAvailable();
      } else {
        savedPredefinedLocations = list;
        yield LoadingPredefinedLocationsSuccess(list);
      }
    } catch (e) {
      yield LoadingPredefinedLocationsError(e.toString());
    }
  }

  Stream<LocationState> mapSelectLocationToState(Location location) async* {
    selectedLocation = location;
    yield LocationSelected(location);
  }

  Stream<LocationState> mapFilterLocationsToState(String filter) async* {
    List<Location> filteredList = savedPredefinedLocations.where((location) {
      return location.location.toLowerCase().contains(filter) ||
          location.address.toLowerCase().contains(filter);
    }).toList();

    yield PredefinedLocationsFiltered(filteredList);
  }

  Stream<LocationState> mapGetPreviousLocationToState() async* {
    yield LocationSelected(selectedLocation);
  }
}
