import 'package:clients/model/location.dart';

class PredefinedLocationsState {
  final List<Location> locations;
  final String selectedCountry;
  final List<Location> filteredLocations;

  PredefinedLocationsState({this.locations, this.selectedCountry, this.filteredLocations});
}

class InitialPredefinedLocationsState extends PredefinedLocationsState {
  InitialPredefinedLocationsState() : super(locations: [], selectedCountry: "101", filteredLocations: []);
}

class LoadingPredefinedLocations extends PredefinedLocationsState {
  LoadingPredefinedLocations({List<Location> locations, String selectedCountry, List<Location> filteredLocations})
      : super(locations: locations, selectedCountry: selectedCountry, filteredLocations: filteredLocations);
}

class ErrorPredefinedLocations extends PredefinedLocationsState {
  final String message;

  ErrorPredefinedLocations(this.message,
      {List<Location> locations, String selectedCountry, List<Location> filteredLocations})
      : super(locations: locations, selectedCountry: selectedCountry, filteredLocations: filteredLocations);
}

class NoAvailablePredefinedLocations extends PredefinedLocationsState {
  NoAvailablePredefinedLocations({List<Location> locations, String selectedCountry, List<Location> filteredLocations})
      : super(locations: locations, selectedCountry: selectedCountry, filteredLocations: filteredLocations);
}
