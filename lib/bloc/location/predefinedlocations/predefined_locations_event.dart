import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PredefinedLocationsEvent extends Equatable {
  const PredefinedLocationsEvent();
}

class GetPredefinedLocations extends PredefinedLocationsEvent {
  GetPredefinedLocations();

  @override
  List<Object> get props => [];
}

class FilterLocations extends PredefinedLocationsEvent {
  final String filter;

  FilterLocations(this.filter);

  @override
  List<Object> get props => [this.filter];
}

class ChangeCountry extends PredefinedLocationsEvent {
  final String countryId;

  ChangeCountry(this.countryId);

  @override
  List<Object> get props => [this.countryId];
}

class InitGetPredefinedLocation extends PredefinedLocationsEvent {
  final String initialCountryToLoad;

  InitGetPredefinedLocation(this.initialCountryToLoad);

  @override
  List<Object> get props => [];
}
