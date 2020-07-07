import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class InitRegisterEvent extends RegisterEvent {
  final String email;
  final String phoneNumber;
  final String name;
  final String imageUrl;

  const InitRegisterEvent({this.email, this.phoneNumber, this.name, this.imageUrl});

  @override
  List<Object> get props => [email, phoneNumber, name, imageUrl];
}

class Register extends RegisterEvent {
  const Register();

  @override
  List<Object> get props => [];
}

class ChangeName extends RegisterEvent {
  final String name;

  const ChangeName(
    this.name,
  );

  @override
  List<Object> get props => [name];
}

class ChangeAvatar extends RegisterEvent {
  final File file;

  const ChangeAvatar(
    this.file,
  );

  @override
  List<Object> get props => [file];
}

class ChangeLocation extends RegisterEvent {
  final String location;

  const ChangeLocation(
    this.location,
  );

  @override
  List<Object> get props => [location];
}

class ChangeReferral extends RegisterEvent {
  final String referral;

  const ChangeReferral(
    this.referral,
  );

  @override
  List<Object> get props => [referral];
}

class ChangeIsUseReferral extends RegisterEvent {
  final bool isUseReferral;

  const ChangeIsUseReferral(
    this.isUseReferral,
  );

  @override
  List<Object> get props => [isUseReferral];
}
