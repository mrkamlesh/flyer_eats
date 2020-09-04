import 'package:clients/model/address.dart';

class User {
  final String name;
  final String phone;
  final bool hasAddress;
  final String token;
  final String avatar;
  final Address defaultAddress;
  final String username;
  final String location;
  final String countryCode;
  final String lastLocation;
  final String mapBoxToken;

  User(
      {this.avatar,
      this.name,
      this.phone,
      this.hasAddress,
      this.token,
      this.defaultAddress,
      this.username,
      this.location,
      this.countryCode,
      this.lastLocation,
      this.mapBoxToken});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    Address defaultAddress = parsedJson['default_address'] == false
        ? null
        : Address(
            parsedJson['default_address']['id'],
            parsedJson['default_address']['location_name'],
            parsedJson['default_address']['address'],
            AddressType.home,
            zipCode: parsedJson['default_address']['zipcode'],
            city: parsedJson['default_address']['city'],
            state: parsedJson['default_address']['state'],
            latitude: parsedJson['default_address']['delivery_latitude'],
            longitude: parsedJson['default_address']['delivery_longitude'],
            mapAddress: parsedJson['default_address']['address'],
          );

    return User(
        name: parsedJson['client_name_cookie'],
        phone: parsedJson['contact_phone'],
        avatar: parsedJson['avatar'],
        hasAddress: parsedJson['has_addressbook'] == '2' ? true : false,
        token: parsedJson['token'],
        username: parsedJson['email'],
        location: parsedJson['location_name'],
        countryCode: parsedJson['country_code'],
        lastLocation: parsedJson['last_location'],
        mapBoxToken: parsedJson['map_key'],
        defaultAddress: defaultAddress);
  }

  User copyWith(
      {String name,
      String phone,
      bool hasAddress,
      String token,
      String avatar,
      Address defaultAddress,
      String username,
      String referralCode,
      String referralDiscount,
      String location,
      String countryCode}) {
    return User(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        username: username ?? this.username,
        token: token ?? this.token,
        hasAddress: hasAddress ?? this.hasAddress,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        countryCode: countryCode ?? this.countryCode,
        location: location ?? this.location);
  }
}
