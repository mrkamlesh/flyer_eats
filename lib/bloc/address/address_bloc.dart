import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/bloc.dart';
import 'package:flyereats/model/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    if (event is InitDefaultAddress) {
      yield* mapInitDefaultAddressToState();
    } else if (event is OpenListAddress) {
      yield* mapOpenListAddressToState();
    } else if (event is OpenAddress) {
      yield* mapOpenAddressToState(event.id);
    } else if (event is CalculatePrice) {
      yield* mapCalculatePriceToState(event.from, event.to);
    } else if (event is AddressAddPageOpen) {
      yield* mapAddressPageOpenToState();
    } else if (event is UpdateAddressLocation) {
      yield* mapUpdateAddressLocationToState(event.latLng);
    } else if (event is UpdateAddressInformation) {
      yield* mapUpdateAddressInformationToState(event);
    } else if (event is AddAddress) {
      yield* mapAddAddressToState(event.address);
    } else if (event is AddressUpdatePageOpen) {
      yield* mapAddressUpdatePageOpenToState(event.address);
    } else if (event is UpdateAddress) {
      yield* mapUpdateAddressToState(event.address);
    } else if (event is RemoveAddress) {
      yield* mapRemoveAddressToState(event.id);
    }
    /*else if (event is ValidatingAddress) {
      yield* mapValidatingAddressToSTate(event.address);
    }*/
  }

  Stream<AddressState> mapInitDefaultAddressToState() async* {
    yield LoadingAddressInformation();
    try {
      //addressRepository.addExampleAddress();
      Address address = await addressRepository.getDefaultAddress();
      if (address == null) {
        yield NoAddressLoaded();
      } else {
        yield AddressLoaded(address);
      }
    } catch (e) {
      yield ErrorLoadingAddressInformation(e.toString());
    }
  }

  Stream<AddressState> mapOpenListAddressToState() async* {
    yield LoadingListAddress();
    try {
      List<Address> list = await addressRepository.getAllAddress();
      yield ListAddressLoaded(list);
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapOpenAddressToState(int id) async* {
    yield LoadingAddressInformation();
    try {
      Address address = await addressRepository.getAddress(id);
      yield AddressLoaded(address);
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapCalculatePriceToState(
      Address from, Address to) async* {
    yield PriceCalculateLoading();
    try {
      // You should get price from repository or API Call here

      //
      yield PriceCalculateSuccess(20.0);
    } catch (e) {
      yield PriceCalculateError(e.toString());
    }
  }

  Stream<AddressState> mapAddressPageOpenToState() async* {
    address = Address(null, null, null, AddressType.home);
    yield LoadingTemporaryAddress();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception();
      });

      add(UpdateAddressLocation(LatLng(position.latitude, position.longitude)));
    } catch (e) {
      yield LoadingTemporaryAddressError("Can not get current location");
    }
  }

  Stream<AddressState> mapUpdateAddressLocationToState(LatLng latLng) async* {
    yield LoadingTemporaryAddress();
    try {
      List<Placemark> placeMark = await Geolocator()
          .placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      Address newAddress = address.copyWith(
          address: placeMark[0].name +
              " " +
              placeMark[0].locality +
              " " +
              placeMark[0].subAdministrativeArea +
              " " +
              placeMark[0].administrativeArea,
          latitude: placeMark[0].position.latitude.toString(),
          longitude: placeMark[0].position.longitude.toString());
      address = newAddress;
      yield LoadingTemporaryAddressSuccess(newAddress, isFromMap: true);
    } catch (e) {
      yield LoadingTemporaryAddressError("Can not get current location");
    }
  }

  Stream<AddressState> mapUpdateAddressInformationToState(
      UpdateAddressInformation event) async* {
    Address newAddress = address.copyWith(
        type: event.type, address: event.address, title: event.title);
    address = newAddress;
    yield LoadingTemporaryAddressSuccess(newAddress);
  }

  Stream<AddressState> mapAddAddressToState(Address address) async* {
    yield LoadingAddressInformation();
    try {
      await addressRepository.addAddress(address);
      yield AddressAdded();
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapAddressUpdatePageOpenToState(
      Address addressEvent) async* {
    address = addressEvent;
    yield LoadingTemporaryAddress();
    try {
      yield LoadingTemporaryAddressSuccess(addressEvent, isFromMap: true);
    } catch (e) {
      yield LoadingTemporaryAddressError("Can not get current location");
    }
  }

  Stream<AddressState> mapUpdateAddressToState(Address address) async* {
    yield LoadingAddressInformation();
    try {
      await addressRepository.updateAddress(address);
      yield AddressUpdated();
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }

  Stream<AddressState> mapRemoveAddressToState(int id) async* {
    yield LoadingAddressInformation();
    try {
      await addressRepository.deleteAddress(id);
      yield AddressRemoved();
      add(OpenListAddress());
    } catch (e) {
      yield ErrorLoadingListAddress(e.toString());
    }
  }
}
