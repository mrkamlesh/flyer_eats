import 'dart:io';

import 'package:flyereats/model/shop.dart';

class PickUp {
  final Shop shop;
  final List<String> items;
  final List<File> attachment;

  PickUp({this.shop, this.items, this.attachment});

  PickUp copyWith({Shop shop, List<String> items, List<File> attachment}) {
    return PickUp(
        shop: shop ?? this.shop,
        items: items ?? this.items,
        attachment: attachment ?? this.attachment);
  }

  bool isValid() {
    return shop != null && items != null && items.length != 0;
  }
}
