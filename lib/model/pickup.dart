import 'dart:io';

import 'package:clients/model/shop.dart';

class PickUp {
  final Shop shop;
  final List<String> items;
  final List<File> attachment;
  final String deliveryInstruction;

  PickUp({
    this.shop,
    this.items,
    this.attachment,
    this.deliveryInstruction,
  });

  PickUp copyWith({Shop shop, List<String> items, List<File> attachment, String deliveryInstruction}) {
    return PickUp(
        shop: shop ?? this.shop,
        items: items ?? this.items,
        attachment: attachment ?? this.attachment,
        deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction);
  }

  bool isValid() {
    return shop.isValid() && items != null && items.length != 0;
  }
}
