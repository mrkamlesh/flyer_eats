enum AddressType { home, office, other }

class Address {
  final String id;
  final String title;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String mapAddress;
  final String latitude;
  final String longitude;
  final AddressType type;

  Address(
    this.id,
    this.title,
    this.address,
    this.type, {
    this.city,
    this.state,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.mapAddress,
  });

  Address copyWith(
      {String id,
      String title,
      String address,
      String city,
      String state,
      String zipCode,
      AddressType type,
      String latitude,
      String longitude,
      String mapAddress}) {
    return Address(
      id ?? this.id,
      title ?? this.title,
      address ?? this.address,
      type ?? this.type,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mapAddress: mapAddress ?? this.mapAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'description': address,
      'latitude': latitude,
      'longitude': longitude,
      'mapAddress': mapAddress,
      'type': type.toString(),
    };
  }

  static Address fromMap(Map<String, dynamic> map) {
    AddressType type;
    if (map['type'] == AddressType.home.toString()) {
      type = AddressType.home;
    } else if (map['type'] == AddressType.office.toString()) {
      type = AddressType.office;
    } else {
      type = AddressType.other;
    }

    return Address(map['id'], map['title'], map['address'], type,
        longitude: map['longitude'],
        latitude: map['latitude'],
        mapAddress: map['mapAddress']);
  }

  bool isValid() {
    return title != null &&
        address != null &&
        latitude != null &&
        longitude != null &&
        type != null &&
        title != "" &&
        address != "";
  }

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(parsedJson['id'], parsedJson['location_name'],
        parsedJson['address'], AddressType.home,
        city: parsedJson['city'],
        zipCode: parsedJson['zipcode'],
        state: parsedJson['state'],
        longitude: parsedJson['delivery_longitude'],
        latitude: parsedJson['delivery_latitude'],
        mapAddress: parsedJson['address']);
  }
}
