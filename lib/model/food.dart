import 'package:clients/classes/style.dart';
import 'package:clients/model/menu_category.dart';
import 'package:clients/model/price.dart';
import 'package:flutter/material.dart';

class Food {
  final String id;
  final String title;
  final String description;
  final String image;
  final bool isVeg;
  final MenuCategory category;
  final Price price;
  final double discount;
  final String badge;
  final bool isSingleItem;

  Food({
    this.id,
    this.title,
    this.description,
    this.image,
    this.isVeg,
    this.category,
    this.price,
    this.discount,
    this.badge,
    this.isSingleItem,
  });

  factory Food.fromJson(Map<String, dynamic> parsedJson) {
    bool isSingleItem = parsedJson['single_item'] == 2 ? true : false;

    return Food(
        id: parsedJson['item_id'],
        title: parsedJson['item_name'],
        description: parsedJson['item_description'],
        image: parsedJson['photo'],
        isVeg: parsedJson['is_veg'],
        price: Price.fromJson(parsedJson['prices'][0]),
        badge: parsedJson['badge'],
        isSingleItem: isSingleItem,
        discount: parsedJson['discount'] != "" ? double.parse(parsedJson['discount']) : 0,
        category: MenuCategory(parsedJson['cat_id'], parsedJson['category_name']));
  }

  double getRealPrice() {
    return this.price.price - this.discount;
  }

  Color getBadgeColor() {
    switch (this.badge.toLowerCase()) {
      case "must try":
        return Colors.green;
      case "recommended":
        return Color(0xFFF33953);
      case "exclusive":
        return Color(0xFFCE2AA0);
      default:
        return primary1;
    }
  }
}
