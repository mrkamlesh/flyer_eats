import 'dart:io';

import 'package:clients/model/location.dart';

class RegisterPost {
  final String countryId;
  final String appVersion;
  final String devicePlatform;
  final String deviceId;
  final String referral;
  final Location location;
  final String email;
  final String name;
  final String imageUrl;
  final File avatar;
  final String contactPhone;
  final bool isUseReferral;

  RegisterPost(
      {this.email,
      this.contactPhone,
      this.name,
      this.imageUrl,
      this.avatar,
      this.countryId,
      this.appVersion,
      this.devicePlatform,
      this.deviceId,
      this.referral,
      this.location,
      this.isUseReferral});

  RegisterPost copyWith(
      {String countryId,
      String appVersion,
      String devicePlatform,
      String deviceId,
      String referral,
      Location location,
      String email,
      String name,
      String imageUrl,
      String contactPhone,
      File avatar,
      bool isUseReferral}) {
    return RegisterPost(
        contactPhone: contactPhone ?? this.contactPhone,
        deviceId: deviceId ?? this.deviceId,
        appVersion: appVersion ?? this.appVersion,
        devicePlatform: devicePlatform ?? this.devicePlatform,
        location: location ?? this.location,
        referral: referral ?? this.referral,
        countryId: countryId ?? this.countryId,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        isUseReferral: isUseReferral ?? this.isUseReferral);
  }

  bool isValid() {
    return name != null && name != "" && email != null && email != "" && location != null;
  }
}
