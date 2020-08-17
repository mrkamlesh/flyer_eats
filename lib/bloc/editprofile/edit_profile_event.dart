import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:clients/model/user_profile.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
}

class InitProfile extends EditProfileEvent {
  final Profile profile;

  InitProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class UpdateName extends EditProfileEvent {
  final String name;

  UpdateName(this.name);

  @override
  List<Object> get props => [name];
}

class UpdatePassword extends EditProfileEvent {
  final String password;

  UpdatePassword(this.password);

  @override
  List<Object> get props => [password];
}

class UpdatePhone extends EditProfileEvent {
  final String phone;

  UpdatePhone(this.phone);

  @override
  List<Object> get props => [phone];
}

class UpdateImage extends EditProfileEvent {
  final File file;

  UpdateImage(this.file);

  @override
  List<Object> get props => [file];
}

class UpdateLocation extends EditProfileEvent {
  final String location;
  final String countryCode;

  UpdateLocation(this.location, this.countryCode);

  @override
  List<Object> get props => [location, countryCode];
}

class UpdateProfile extends EditProfileEvent {
  final String token;

  UpdateProfile(this.token);

  @override
  List<Object> get props => [token];
}
