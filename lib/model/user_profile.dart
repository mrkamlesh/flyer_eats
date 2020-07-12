import 'dart:io';

class Profile {
  final String name;
  final String phone;
  final String password;
  final File avatar;

  Profile({this.name, this.phone, this.password, this.avatar});

  Profile copyWith({String name, String phone, String password, File avatar}) {
    return Profile(
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        password: password ?? this.password,
        phone: phone ?? this.phone);
  }

  bool isValid() {
    return this.name != null && this.name != "" && this.phone != null && this.phone != "";
  }
}
