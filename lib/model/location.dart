class Location {
  final String id;
  final String address;
  final String location;
  final double latitude;
  final double longitude;
  final String country;

  Location(
      {this.country,
      this.id,
      this.address,
      this.location,
      this.latitude,
      this.longitude});

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
      address: parsedJson['address'],
      latitude: double.parse(parsedJson['latitude']),
      longitude: double.parse(parsedJson['longitude']),
      location: parsedJson['location'],
      id: parsedJson['id'],
      country: parsedJson['country_id'],
    );
  }
}
