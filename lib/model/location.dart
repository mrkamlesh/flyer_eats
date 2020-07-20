class Location {
  final String id;
  final String address;
  final String location;
  final double latitude;
  final double longitude;
  final String country;

  final String street;
  final String city;
  final String state;
  final String locationName;

  Location(
      {this.country,
      this.id,
      this.street,
      this.city,
      this.state,
      this.locationName,
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

  factory Location.fromHomePageJson(Map<String, dynamic> parsedJson){
    return Location(
      address: parsedJson['address'],
      state: parsedJson['state'],
      city: parsedJson['city'],
      locationName: parsedJson['location_name'],
      street: parsedJson['street']
    );
  }
}
