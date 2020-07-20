import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/home_page_data.dart';
import 'package:clients/model/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  DataRepository repository = DataRepository();
  List<Location> savedPredefinedLocations = List();
  HomePageData prevData = HomePageData();

  @override
  LocationState get initialState => InitialLocationState();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is GetCurrentLocation) {
      yield* mapGetCurrentLocationToState(event.token);
    } else if (event is UpdateLocation) {
      yield* mapUpdateLocationToState(event.latLng);
    } else if (event is MoveLocation) {
      yield* mapMoveLocationToState(event.latLng);
    } else if (event is GetPredefinedLocations) {
      yield* mapGetPredefinedLocationsToState(event.countryId);
    } else if (event is GetHomeDataByLocation) {
      yield* mapGetHomeDataByLocationToState(event.token, event.location);
    } else if (event is FilterLocations) {
      yield* mapFilterLocationsToState(event.filter);
    } else if (event is GetPreviousLocation) {
      yield* mapGetPreviousLocationToState();
    } else if (event is GetHomeDataByLatLng) {
      yield* mapGetHomeDataByLatLngToState(event.token, event.lat, event.lng);
    }
  }

  Stream<LocationState> mapGetCurrentLocationToState(String token) async* {
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

      add(GetHomeDataByLatLng(token, position.latitude, position.longitude));
    } catch (e) {
      yield LoadingLocationError("Can not get location");
    }
  }

  Stream<LocationState> mapUpdateLocationToState(LatLng latLng) async* {
    yield UpdatingLocation();
    try {
      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      yield UpdatingLocationSuccess(Location(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
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

  Stream<LocationState> mapGetPredefinedLocationsToState(String countryId) async* {
    yield LoadingPredefinedLocations();
    try {
      List<Location> list = await repository.getLocations(countryId);
      if (list.isEmpty) {
        yield NoLocationsAvailable();
      } else {
        savedPredefinedLocations = list;
        yield LoadingPredefinedLocationsSuccess(list);
      }
    } catch (e) {
      yield LoadingPredefinedLocationsError(e.toString());
    }
  }

  Stream<LocationState> mapFilterLocationsToState(String filter) async* {
    yield LoadingPredefinedLocations();

    try {
      List<Location> filteredList = savedPredefinedLocations.where((location) {
        return location.location.toLowerCase().contains(filter) || location.address.toLowerCase().contains(filter);
      }).toList();

      if (filteredList.isNotEmpty) {
        yield PredefinedLocationsFiltered(filteredList);
      } else {
        yield NoLocationsAvailable();
      }
    } catch (e) {
      yield LoadingPredefinedLocationsError(e.toString());
    }
  }

  Stream<LocationState> mapGetPreviousLocationToState() async* {
    yield HomePageDataLoaded(prevData);
  }

  Stream<LocationState> mapGetHomeDataByLatLngToState(String token, double lat, double lng) async* {
    yield LoadingLocation();
    try {
      var data = await repository.getHomePageData(
          token: token, lat: lat, long: lng, topRestaurantPage: 0, foodCategoryPage: 0, dblPage: 0, adsPage: 0);
      if (data is HomePageData) {
        prevData = data;
        yield HomePageDataLoaded(data);
      } else {
        yield NoLocationsAvailable();
      }
    } catch (e) {
      yield LoadingLocationError("Can not get location");
    }
  }

  Stream<LocationState> mapGetHomeDataByLocationToState(String token, Location location) async* {
    yield LoadingLocation();

    try {
      var data = await repository.getHomePageData(
          token: token, address: location.address, topRestaurantPage: 0, foodCategoryPage: 0, dblPage: 0, adsPage: 0);

      if (data is HomePageData) {
        prevData = data;
        yield HomePageDataLoaded(data);
      } else {
        yield NoLocationsAvailable();
      }
    } catch (e) {
      yield LoadingLocationError("Can not get location");
    }
  }
}
