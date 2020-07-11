import 'package:flyereats/model/menu_category.dart';

class Food {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isAvailable;
  final double discount;
  final String formattedPrice;
  final String formattedDiscountPrice;
  final MenuCategory category;

  Food({
    this.id,
    this.title,
    this.description,
    this.price,
    this.image,
    this.isAvailable,
    this.discount,
    this.formattedPrice,
    this.formattedDiscountPrice,
    this.category,
  });

  factory Food.fromJson(Map<String, dynamic> parsedJson) {
    bool available = parsedJson['not_available'] == "1" ? false : true;

    return Food(
        id: parsedJson['item_id'],
        title: parsedJson['item_name'],
        description: parsedJson['item_description'],
        price: double.parse(parsedJson['prices'][0]['price']),
        image: parsedJson['photo'],
        isAvailable: available,
        discount: parsedJson['discount'] != ""
            ? double.parse(parsedJson['discount'])
            : 0,
        formattedPrice: parsedJson['prices'][0]['formatted_price'],
        formattedDiscountPrice: parsedJson['prices'][0]
            ['price_discount_pretty'],
        category:
            MenuCategory(parsedJson['cat_id'], parsedJson['category_name']));
  }

  double getRealPrice(){
    return price - discount;
  }
}
