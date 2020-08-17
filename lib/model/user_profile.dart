import 'dart:io';

class Profile {
  final String name;
  final String phone;
  final String password;
  final File avatar;
  final String location;
  final String countryCode;

  Profile(
      {this.name,
      this.phone,
      this.password,
      this.avatar,
      this.location,
      this.countryCode});

  Profile copyWith(
      {String name,
      String phone,
      String password,
      File avatar,
      String location,
      String countryCode}) {
    return Profile(
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
        location: location ?? this.location);
  }

  bool isValid() {
    return this.name != null &&
        this.name != "" &&
        this.phone != null &&
        this.phone != "" &&
        this.location != null &&
        this.location != "";
  }
}
