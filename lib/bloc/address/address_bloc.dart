import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flyereats/bloc/address/address_repository.dart';
import 'package:flyereats/bloc/address/bloc.dart';
import 'package:flyereats/model/address.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

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
    }
    /*else if (event is AddAddress) {
      yield* mapAddAddressToState(event.address);
    } else if (event is UpdateAddress) {
      yield* mapUpdateAddressToState(event.address);
    } else if (event is RemoveAddress) {
      yield* mapRemoveAddressToState(event.id);
    } else if (event is ValidatingAddress) {
      yield* mapValidatingAddressToSTate(event.address);
    }*/
  }

  Stream<AddressState> mapInitDefaultAddressToState() async* {
    yield LoadingAddressInformation();
    await Future.delayed(Duration(milliseconds: 1000));
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
    await Future.delayed(Duration(milliseconds: 1000));
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
    await Future.delayed(Duration(milliseconds: 1000));
    try {
      // You should get price from repository or API Call here

      //
      yield PriceCalculateSuccess(20.0);
    } catch (e) {
      yield PriceCalculateError(e.toString());
    }
  }

/* 
  Stream<AddressState> mapAddAddressToState(Address address) async* {
    yield Loading();
    try {
      await addressRepository.addAddress(address);
      yield AddressAdded();
    } catch (e) {
      yield ErrorLoading(e.toString());
    }
  }

  Stream<AddressState> mapUpdateAddressToState(Address address) async* {
    yield Loading();
    try {
      await addressRepository.updateAddress(address);
      yield AddressUpdated();
    } catch (e) {
      yield ErrorLoading(e.toString());
    }
  }

  Stream<AddressState> mapRemoveAddressToState(int id) async* {
    yield Loading();
    try {
      await addressRepository.deleteAddress(id);
      yield AddressRemoved();
    } catch (e) {
      yield ErrorLoading(e.toString());
    }
  }*/
}
