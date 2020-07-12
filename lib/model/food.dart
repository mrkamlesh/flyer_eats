import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/price.dart';

class Food {
  final String id;
  final String title;
  final String description;
  final String image;
  final bool isAvailable;
  final MenuCategory category;
  final List<Price> prices;
  final double discount;

  Food({
    this.id,
    this.title,
    this.description,
    this.image,
    this.isAvailable,
    this.category,
    this.prices,
    this.discount,
  });

  factory Food.fromJson(Map<String, dynamic> parsedJson) {
    bool available = parsedJson['not_available'] == "1" ? false : true;
    var priceJson = parsedJson['prices'] as List;
    List<Price> priceList = priceJson.map((i) {
      return Price.fromJson(i);
    }).toList();

    return Food(
        id: parsedJson['item_id'],
        title: parsedJson['item_name'],
        description: parsedJson['item_description'],
        image: parsedJson['photo'],
        isAvailable: available,
        prices: priceList,
        discount: parsedJson['discount'] != "" ? double.parse(parsedJson['discount']) : 0,
        category: MenuCategory(parsedJson['cat_id'], parsedJson['category_name']));
  }

  double getRealPrice(int index) {
    return this.prices[index].price - this.discount;
  }

  Food changeSelectedPrice(int index) {
    return Food(
        id: this.id,
        title: this.title,
        category: this.category,
        description: this.description,
        discount: this.discount,
        image: this.image,
        isAvailable: this.isAvailable,
        prices: this.prices);
  }
}
