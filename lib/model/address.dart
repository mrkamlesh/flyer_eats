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
  final bool isDefault;
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
    this.isDefault,
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
      String mapAddress,
      bool isDefault}) {
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
      isDefault: isDefault ?? this.isDefault,
    );
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
    AddressType type;
    if (parsedJson['type'] == "home") {
      type = AddressType.home;
    } else if (parsedJson['type'] == "office") {
      type = AddressType.office;
    } else {
      type = AddressType.other;
    }

    return Address(parsedJson['id'], parsedJson['location_name'],
        parsedJson['address'], type,
        city: parsedJson['city'],
        zipCode: parsedJson['zipcode'],
        state: parsedJson['state'],
        isDefault: parsedJson['as_default'] == "1" ? false : true,
        longitude: parsedJson['delivery_longitude'],
        latitude: parsedJson['delivery_latitude'],
        mapAddress: parsedJson['address']);
  }

  String getType() {
    if (type == AddressType.home) {
      return "home";
    } else if (type == AddressType.office) {
      return "office";
    } else {
      return "other";
    }
  }
}
