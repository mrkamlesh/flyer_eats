import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/classes/app_util.dart';
import 'package:geolocator/geolocator.dart';
import './bloc.dart';

class CurrentLocationBloc
    extends Bloc<CurrentLocationEvent, CurrentLocationState> {
  @override
  CurrentLocationState get initialState => InitialCurrentLocationState();

  @override
  Stream<CurrentLocationState> mapEventToState(
    CurrentLocationEvent event,
  ) async* {
    if (event is GetCurrentLocationEvent) {
      yield* mapGetCurrentLocationToState();
    } else if (event is UpdateAddress) {
      yield* mapUpdateAddressToState(event.lat, event.lng);
    }
  }

  Stream<CurrentLocationState> mapGetCurrentLocationToState() async* {
    yield LoadingCurrentLocationState(
        lat: state.lat, lng: state.lng, address: state.address);
    await AppUtil.checkLocationServiceAndPermission();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw AppException(
            "Can not Get Current Location. Click Anywhere in the Map to Select Shop",
            "");
      });

      List<Placemark> placeMark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      String thoroughfare =
          (placeMark[0].thoroughfare != "" && placeMark[0].thoroughfare != null)
              ? placeMark[0].thoroughfare + " "
              : "";
      String subThoroughfare = (placeMark[0].subThoroughfare != "" &&
              placeMark[0].subThoroughfare != null)
          ? placeMark[0].subThoroughfare + " "
          : "";
      String subLocality =
          (placeMark[0].subLocality != "" && placeMark[0].subLocality != null)
              ? placeMark[0].subLocality + " "
              : "";
      String locality =
          (placeMark[0].locality != "" && placeMark[0].locality != null)
              ? placeMark[0].locality + " "
              : "";
      String subAdministrativeArea =
          (placeMark[0].subAdministrativeArea != "" &&
                  placeMark[0].subAdministrativeArea != null)
              ? placeMark[0].subAdministrativeArea + " "
              : "";
      String administrativeArea = (placeMark[0].administrativeArea != "" &&
              placeMark[0].administrativeArea != null)
          ? placeMark[0].administrativeArea + " "
          : "";
      String postalCode =
          (placeMark[0].postalCode != "" && placeMark[0].postalCode != null)
              ? placeMark[0].postalCode + " "
              : "";

      yield CurrentLocationState(
        lat: position.latitude,
        lng: position.longitude,
        address: thoroughfare +
            subThoroughfare +
            subLocality +
            locality +
            subAdministrativeArea +
            administrativeArea +
            postalCode,
      );
    } catch (e) {
      yield ErrorCurrentLocationState("Can not get current location",
          lng: state.lng, lat: state.lat, address: state.address);
    }
  }

  Stream<CurrentLocationState> mapUpdateAddressToState(
      double lat, double lng) async* {
    yield LoadingCurrentLocationState(
        lat: lat, lng: lng, address: state.address);
    try {
      List<Placemark> placeMark =
          await Geolocator().placemarkFromCoordinates(lat, lng);

      yield CurrentLocationState(
          lat: lat,
          lng: lng,
          address: placeMark[0].name +
              " " +
              placeMark[0].locality +
              " " +
              placeMark[0].subAdministrativeArea +
              " " +
              placeMark[0].administrativeArea);
    } catch (e) {
      yield ErrorCurrentLocationState(e.toString(),
          lng: lat, lat: lng, address: "...");
    }
  }
}
