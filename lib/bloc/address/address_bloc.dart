import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clients/bloc/address/address_repository.dart';
import 'package:clients/bloc/address/bloc.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/model/address.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  Address address;

  AddressBloc(this.addressRepository);

  @override
  AddressState get initialState => InitState();

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    if (event is OpenListAddress) {
      yield* mapOpenListAddressToState(event.token);
    } else if (event is OpenAddress) {
      yield* mapOpenAddressToState(event.id, event.token);
    } else if (event is AddressAddPageOpen) {
      yield* mapAddressAddPageOpenToState();
    } else if (event is UpdateAddressLocation) {
      yield* mapUpdateAddressLocationToState(event.lat, event.lng);
    } else if (event is UpdateAddressInformation) {
      yield* mapUpdateAddressInformationToState(event);
    } else if (event is AddAddress) {
      yield* mapAddAddressToState(event.address, event.token);
    } else if (event is AddressUpdatePageOpen) {
      yield* mapAddressUpdatePageOpenToState(event.address);
    } else if (event is UpdateAddress) {
      yield* mapUpdateAddressToState(event.address, event.token);
    } else if (event is RemoveAddress) {
      yield* mapRemoveAddressToState(event.id, event.token);
    }
  }

  Stream<AddressState> mapOpenListAddressToState(String token) async* {
    yield LoadingListAddress();
    try {
      List<Address> list = await addressRepository.getAllAddress(token);
      yield ListAddressLoaded(list);
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapOpenAddressToState(String id, String token) async* {
    yield LoadingAddressInformation();
    try {
      Address address = await addressRepository.getAddress(id, token);
      yield AddressLoaded(address);
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapAddressAddPageOpenToState() async* {
    address = Address(null, null, null, AddressType.home, isDefault: false);
    yield LoadingTemporaryAddress();
    await AppUtil.checkLocationServiceAndPermission();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 3), onTimeout: () {
        throw AppException(
            "Unable to fetch your Current Location, Click the MAP to select the address",
            "");
      });

      if (position != null) {
        yield SuccessGetLocation(position.latitude, position.longitude);
      }

      add(UpdateAddressLocation(position.latitude, position.longitude));
    } on PlatformException {
      yield LoadingTemporaryAddressError(
          "Unable to fetch your Current Location, Click the MAP to select the address");
    } catch (e) {
      yield LoadingTemporaryAddressError(
          "Unable to fetch your Current Location, Click the MAP to select the address");
    }
  }

  Stream<AddressState> mapUpdateAddressLocationToState(
      double lat, double lng) async* {
    yield LoadingTemporaryAddress();
    try {
      List<Placemark> placeMark =
          await Geolocator().placemarkFromCoordinates(lat, lng);

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

      Address newAddress = address.copyWith(
          address: thoroughfare +
              subThoroughfare +
              subLocality +
              locality +
              subAdministrativeArea +
              administrativeArea +
              postalCode,
          state: placeMark[0].administrativeArea,
          city: placeMark[0].locality,
          zipCode: placeMark[0].postalCode,
          latitude: lat.toString(),
          longitude: lng.toString());
      address = newAddress;
      yield LoadingTemporaryAddressSuccess(newAddress, isFromMap: true);
    } catch (e) {
      yield LoadingTemporaryAddressError("Can not get current location");
    }
  }

  Stream<AddressState> mapUpdateAddressInformationToState(
      UpdateAddressInformation event) async* {
    Address newAddress = address.copyWith(
        type: event.type,
        address: event.address,
        title: event.title,
        isDefault: event.isDefault);
    address = newAddress;
    yield LoadingTemporaryAddressSuccess(newAddress);
  }

  Stream<AddressState> mapAddAddressToState(
      Address address, String token) async* {
    yield LoadingTemporaryAddress();
    try {
      bool isAdded = await addressRepository.addAddress(address, token);
      if (isAdded) {
        yield AddressAdded(isAdded, address);
      } else {
        yield ErrorLoadingListAddress("Error");
      }
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapUpdateAddressToState(
      Address address, String token) async* {
    yield LoadingTemporaryAddress();
    try {
      bool isUpdated = await addressRepository.updateAddress(address, token);
      yield AddressUpdated(address, isUpdated);
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapAddressUpdatePageOpenToState(
      Address addressEvent) async* {
    address = addressEvent;
    yield LoadingTemporaryAddress();
    try {
      await Future.delayed(Duration(milliseconds: 500));
      yield SuccessGetLocation(
          double.parse(address.latitude), double.parse(address.longitude));
      yield LoadingTemporaryAddressSuccess(addressEvent, isFromMap: true);
    } catch (e) {
      yield LoadingTemporaryAddressError("Can not get current location");
    }
  }

  Stream<AddressState> mapRemoveAddressToState(String id, String token) async* {
    yield LoadingAddressInformation();
    try {
      bool isRemoved = await addressRepository.deleteAddress(id, token);
      yield AddressRemoved(isRemoved);
      add(OpenListAddress(token));
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }
}
