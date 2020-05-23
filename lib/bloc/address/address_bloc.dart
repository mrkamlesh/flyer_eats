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
    } else if (event is OpenAddress) {
    } else if (event is AddAddress) {
    } else if (event is UpdateAddress) {
    } else if (event is RemoveAddress) {
    } else if (event is ValidatingAddress) {}
  }

  Stream<AddressState> mapInitDefaultAddressToState() async* {
    yield Loading();
    try {
      List<Address> list = await addressRepository.getAllAddress();
      yield AddressLoaded(list[0]);
    } catch (e) {
      yield ErrorLoading(e.toString());
    }
  }
}
