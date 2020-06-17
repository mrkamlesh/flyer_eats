import 'package:flyereats/bloc/address/address_provider.dart';
import 'package:flyereats/model/address.dart';

class AddressRepository {
  AddressProvider provider = AddressProvider();

  Future<bool> deleteAddress(String id, String token) async {
    final response = await provider.deleteAddress(id, token);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addAddress(Address address, String token) async {
    final response = await provider.addAddress(address, token);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateAddress(Address address, String token) async {
    final response = await provider.updateAddress(address, token);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<Address> getAddress(String id, String token) async {
    final response = await provider.getAddress(id, token);
    if (response['code'] == 1) {
      var addressResponse = response['details'];
      Address address = Address.fromJson(addressResponse);
      return address;
    } else {
      return null;
    }
  }

  Future<List<Address>> getAllAddress(String token) async {
    final response = await provider.getAllAddress(token);
    if (response['code'] == 1) {
      if (response['details'] != "") {
        var listAddresses = response['details'] as List;
        List<Address> addresses = listAddresses.map((i) {
          return Address.fromJson(i);
        }).toList();
        return addresses;
      } else {
        return List();
      }
    } else {
      return List();
    }
  }
}
