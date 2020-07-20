class Shop {
  final String name;
  final String description;
  final String address;
  final double long;
  final double lat;

  Shop({this.name, this.address, this.long, this.lat, this.description});

  bool isValid() {
    return name != null &&
        name != "" &&
        address != null &&
        address != "" &&
        lat != null &&
        long != null &&
        description != null &&
        description != "";
  }

  Shop copyWith({String name, String address, double long, double lat, String description}) {
    return Shop(
        name: name ?? this.name,
        address: address ?? this.address,
        long: long ?? this.long,
        lat: lat ?? this.lat,
        description: description ?? this.description);
  }
}
