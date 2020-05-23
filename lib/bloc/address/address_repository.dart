import 'package:flyereats/bloc/address/address_provider.dart';
import 'package:flyereats/model/address.dart';

class AddressRepository {
  AddressDBProvider provider = AddressDBProvider.db;

  Future addAddress(Address address) {
    return provider.addAddress(address);
  }

  Future updateAddress(Address address) {
    return provider.updateAddress(address);
  }

  Future deleteAddress(int id) {
    return provider.deleteAddress(id);
  }

  Future<Address> getAddress(int id) {
    return provider.getAddress(id);
  }

  Future<Address> getDefaultAddress() {
    return provider.getDefaultAddress();
  }

  Future<List<Address>> getAllAddress() {
    return provider.getAllAddress();
  }

  Future addExampleAddress(){
    return provider.addExampleAddress();
  }
}
