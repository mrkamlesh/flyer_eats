import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class Register extends RegisterEvent {
  final String contactPhone;
  final String email;
  final String referralCode;
  final String fullName;
  final String countryCode;
  final String locationName;
  final String deviceId;
  final String appVersion;
  final String devicePlatform;
  final File avatar;

  const Register(
      {this.contactPhone,
      this.email,
      this.referralCode,
      this.fullName,
      this.countryCode,
      this.locationName,
      this.deviceId,
      this.appVersion,
      this.devicePlatform,
      this.avatar});

  @override
  List<Object> get props => [
        contactPhone,
        email,
        referralCode,
        fullName,
        countryCode,
        locationName,
        deviceId,
        appVersion,
        devicePlatform,
        avatar
      ];
}

class GetLocations extends RegisterEvent {
  const GetLocations();

  @override
  List<Object> get props => [];
}
