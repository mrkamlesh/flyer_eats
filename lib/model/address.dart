enum AddressType { home, office, other }

class Address {
  final int id;
  final String title;
  final String address;
  final String latitude;
  final String longitude;
  final AddressType type;

  Address(this.id, this.title, this.address, this.type,
      {this.latitude, this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'description': address,
      'latitude': latitude,
      'longitude': longitude,
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
        longitude: map['longitude'], latitude: map['latitude']);
  }
}
