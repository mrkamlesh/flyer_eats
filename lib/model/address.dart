enum AddressType { home, office, other }

class Address {
  final int id;
  final String title;
  final String address;
  final String mapAddress;
  final String latitude;
  final String longitude;
  final AddressType type;

  Address(
    this.id,
    this.title,
    this.address,
    this.type, {
    this.latitude,
    this.longitude,
    this.mapAddress,
  });

  Address copyWith(
      {String id,
      String title,
      String address,
      AddressType type,
      String latitude,
      String longitude,
      String mapAddress}) {
    return Address(
      id ?? this.id,
      title ?? this.title,
      address ?? this.address,
      type ?? this.type,
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
}
