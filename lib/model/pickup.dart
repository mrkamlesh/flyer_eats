import 'dart:io';

import 'package:flyereats/model/location.dart';

class PickUp {
  final Shop shop;
  final List<String> items;
  final List<File> attachment;

  PickUp(this.shop, this.items, this.attachment);
}
