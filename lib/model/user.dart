import 'package:flyereats/model/address.dart';

class User {
  final String name;
  final String username;
  final String phone;
  final bool hasAddress;
  final String token;
  final String avatar;
  final String password;
  final Address defaultAddress;

  User(
      {this.password,
      this.avatar,
      this.name,
      this.username,
      this.phone,
      this.hasAddress,
      this.token,
      this.defaultAddress});

  factory User.fromJson(
      Map<String, dynamic> parsedJson, String username, String password) {
    return User(
        name: parsedJson['client_name_cookie'],
        phone: parsedJson['contact_phone'],
        username: username,
        password: password,
        avatar: parsedJson['avatar'],
        hasAddress: parsedJson['has_addressbook'] == '2' ? true : false,
        token: parsedJson['token'],
        defaultAddress: Address(
            parsedJson['default_address']['id'],
            parsedJson['default_address']['location_name'],
            parsedJson['default_address']['address'],
            AddressType.home,
            latitude: parsedJson['default_address']['delivery_latitude'],
            longitude: parsedJson['default_address']['delivery_longitude'],
            mapAddress: parsedJson['default_address']['address']));
  }
}
