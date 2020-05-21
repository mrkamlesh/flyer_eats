import 'package:flutter/material.dart';

class Address{
  final String title;
  final String address;
  final String latitude;
  final String longitude;
  final IconData iconData;

  Address(this.title, this.address, {this.latitude, this.longitude, this.iconData});
}