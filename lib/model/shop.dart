class Shop {
  final String name;
  final String address;
  final String long;
  final String lat;

  Shop({this.name, this.address, this.long, this.lat});

  bool isValid() {
    return name != null && name != "" && address != null && address != "";
  }

  Shop copyWith({String name, String address, String long, String lat}) {
    return Shop(
        name: name ?? this.name,
        address: address ?? this.address,
        long: long ?? this.long,
        lat: lat ?? this.lat);
  }
}
