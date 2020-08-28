import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/pickup/chooseshop/choose_shop_state.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/model/shop.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bloc.dart';

class ChooseShopBloc extends Bloc<ChooseShopEvent, ChooseShopState> {
  @override
  ChooseShopState get initialState => InitialState();

  @override
  Stream<ChooseShopState> mapEventToState(
    ChooseShopEvent event,
  ) async* {
    if (event is EntryShopName) {
      yield* mapEntryShopNameToState(event.name);
    } else if (event is EntryDescription) {
      yield* mapEntryDescriptionToState(event.description);
    } else if (event is EntryAddress) {
      yield* mapEntryAddressToState(event.address);
    } else if (event is PageOpen) {
      yield* mapPageOpenToState(event.shop);
    } else if (event is UpdateLatLng) {
      yield* mapUpdateLatLngToState(event.latLng);
    }
  }

  Stream<ChooseShopState> mapEntryShopNameToState(String name) async* {
    yield ChooseShopState(shop: state.shop.copyWith(name: name));
  }

  Stream<ChooseShopState> mapEntryDescriptionToState(
      String description) async* {
    yield ChooseShopState(shop: state.shop.copyWith(description: description));
  }

  Stream<ChooseShopState> mapEntryAddressToState(String address) async* {
    yield ChooseShopState(shop: state.shop.copyWith(address: address));
  }

  Stream<ChooseShopState> mapPageOpenToState(Shop shop) async* {
    yield LoadingState(shop: state.shop);
    if (shop.lat == null && shop.long == null) {
      try {
        await AppUtil.checkLocationServiceAndPermission();
        Position position;
        position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
            .timeout(Duration(seconds: 3), onTimeout: () {
          throw AppException(
              "Unable to fetch your Current Location, Click the MAP to select the address",
              "");
        });

        String address = await _getGeolocationAddress(
            LatLng(position.latitude, position.longitude));

        yield ChooseShopState(
            shop: Shop(
                long: position.longitude,
                lat: position.latitude,
                address: address));
      } catch (e) {
        yield ErrorState(e.toString(), shop: shop);
      }
    } else {
      yield ChooseShopState(shop: shop);
    }
  }

  Stream<ChooseShopState> mapUpdateLatLngToState(LatLng latLng) async* {
    yield LoadingState(shop: state.shop);

    String address = await _getGeolocationAddress(latLng);

    yield ChooseShopState(
        shop: state.shop.copyWith(
            lat: latLng.latitude, long: latLng.longitude, address: address));
  }

  Future<String> _getGeolocationAddress(LatLng latLng) async {
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);

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
    String subAdministrativeArea = (placeMark[0].subAdministrativeArea != "" &&
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

    return thoroughfare +
        subThoroughfare +
        subLocality +
        locality +
        subAdministrativeArea +
        administrativeArea +
        postalCode;
  }
}
