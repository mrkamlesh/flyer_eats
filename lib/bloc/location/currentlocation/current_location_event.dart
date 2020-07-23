import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CurrentLocationEvent extends Equatable {
  const CurrentLocationEvent();
}

class GetCurrentLocationEvent extends CurrentLocationEvent {
  GetCurrentLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateAddress extends CurrentLocationEvent {
  final double lat;
  final double lng;

  UpdateAddress(this.lat, this.lng);

  @override
  List<Object> get props => [lat, lng];
}
