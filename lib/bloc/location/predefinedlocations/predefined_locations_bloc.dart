import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/data_repository.dart';
import 'package:clients/model/location.dart';
import 'package:geolocator/geolocator.dart';
import './bloc.dart';

class PredefinedLocationsBloc
    extends Bloc<PredefinedLocationsEvent, PredefinedLocationsState> {
  DataRepository repository = DataRepository();

  @override
  PredefinedLocationsState get initialState =>
      InitialPredefinedLocationsState();

  @override
  Stream<PredefinedLocationsState> mapEventToState(
    PredefinedLocationsEvent event,
  ) async* {
    if (event is GetPredefinedLocations) {
      yield* mapGetPredefinedLocationsToState();
    } else if (event is FilterLocations) {
      yield* mapFilterLocationsToState(event.filter);
    } else if (event is ChangeCountry) {
      yield* mapChangeCountryToState(event.countryId);
    } else if (event is InitGetPredefinedLocation) {
      yield* mapInitGetPredefinedLocationToState();
    }
  }

  Stream<PredefinedLocationsState> mapGetPredefinedLocationsToState() async* {
    yield LoadingPredefinedLocations(
        locations: state.locations,
        selectedCountry: state.selectedCountry,
        filteredLocations: []);
    try {
      List<Location> list =
          await repository.getLocations(state.selectedCountry);
      if (list.isEmpty) {
        yield NoAvailablePredefinedLocations(
            locations: list,
            selectedCountry: state.selectedCountry,
            filteredLocations: list);
      } else {
        yield PredefinedLocationsState(
            locations: list,
            selectedCountry: state.selectedCountry,
            filteredLocations: list);
      }
    } catch (e) {
      yield ErrorPredefinedLocations(e.toString(),
          locations: state.locations,
          selectedCountry: state.selectedCountry,
          filteredLocations: []);
    }
  }

  Stream<PredefinedLocationsState> mapFilterLocationsToState(
      String filter) async* {
    yield LoadingPredefinedLocations(
        locations: state.locations,
        selectedCountry: state.selectedCountry,
        filteredLocations: state.filteredLocations);

    try {
      List<Location> filteredList = state.locations.where((location) {
        return location.location.toLowerCase().contains(filter) ||
            location.address.toLowerCase().contains(filter);
      }).toList();

      if (filteredList.isEmpty) {
        yield NoAvailablePredefinedLocations(
            locations: state.locations,
            selectedCountry: state.selectedCountry,
            filteredLocations: filteredList);
      } else {
        yield PredefinedLocationsState(
            locations: state.locations,
            selectedCountry: state.selectedCountry,
            filteredLocations: filteredList);
      }
    } catch (e) {
      yield ErrorPredefinedLocations(e.toString(),
          locations: state.locations,
          selectedCountry: state.selectedCountry,
          filteredLocations: []);
    }
  }

  Stream<PredefinedLocationsState> mapChangeCountryToState(
      String countryId) async* {
    yield PredefinedLocationsState(
        locations: state.locations,
        selectedCountry: countryId,
        filteredLocations: state.filteredLocations);
    add(GetPredefinedLocations());
  }

  Stream<PredefinedLocationsState>
      mapInitGetPredefinedLocationToState() async* {
    yield InitialPredefinedLocationsState();

    try {
      await AppUtil.checkLocationServiceAndPermission();
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 5), onTimeout: () {
        return null;
      });

      String countryCode;

      if (position != null) {
        List<Placemark> placeMark = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);

        if (placeMark[0].isoCountryCode == "SG") {
          countryCode = "196";
        } else {
          countryCode = "101";
        }
      } else {
        countryCode = "101";
      }

      List<Location> list = await repository.getLocations(countryCode);

      if (list.isEmpty) {
        yield NoAvailablePredefinedLocations(
            locations: list,
            selectedCountry: countryCode,
            filteredLocations: list);
      } else {
        yield PredefinedLocationsState(
            locations: list,
            selectedCountry: countryCode,
            filteredLocations: list);
      }
    } catch (e) {
      yield ErrorPredefinedLocations("Can not get current location",
          locations: state.locations,
          selectedCountry: state.selectedCountry,
          filteredLocations: []);
    }
  }
}
