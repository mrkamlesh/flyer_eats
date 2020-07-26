import 'package:clients/model/food.dart';
import 'package:clients/model/ratings.dart';

class Restaurant {
  final String id;
  final String name;
  final String image;
  final String deliveryEstimation;
  final Rating rating;
  final String cuisine;
  final String address;
  final String discountTitle;
  final String discountDescription;
  final bool isOpen;

  final List<Food> searchFoodList;

  Restaurant(
      this.id, this.name, this.deliveryEstimation, this.rating, this.image, this.cuisine, this.address, this.isOpen,
      {this.discountTitle, this.discountDescription, this.searchFoodList});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    var offers = parsedJson['offers'] as List;

    return Restaurant(
      parsedJson['merchant_id'],
      parsedJson['restaurant_name'],
      parsedJson['delivery_estimation'],
      Rating.fromJson(parsedJson['ratings']),
      parsedJson['logo'],
      parsedJson['cuisine'],
      parsedJson['address'],
      parsedJson['is_open'] == "open" ? true : false,
      discountTitle: offers.isNotEmpty ? offers[0] : null,
      discountDescription: offers.isNotEmpty ? offers[0] : null,
    );
  }

  factory Restaurant.fromJsonTopRestaurant(Map<String, dynamic> parsedJson) {
    String promoTitle = (parsedJson['offers'] as List).isNotEmpty ? parsedJson['offers'][0] : "";

    return Restaurant(parsedJson['merchant_id'], parsedJson['restaurant_name'], "", null, parsedJson['logo'], "", "",
        parsedJson['is_open'] == "open" ? true : false,
        discountTitle: promoTitle, discountDescription: "");
  }

  factory Restaurant.fromJsonDblRestaurant(Map<String, dynamic> parsedJson) {
    String promoTitle = (parsedJson['offers'] as List).isNotEmpty ? parsedJson['offers'][0] : "";

    return Restaurant(parsedJson['merchant_id'], parsedJson['restaurant_name'], "", null, parsedJson['logo'], "", "",
        parsedJson['is_open'] == "open" ? true : false,
        discountTitle: promoTitle, discountDescription: "");
  }

  factory Restaurant.fromJsonOrderAgain(Map<String, dynamic> parsedJson) {
    String promoTitle = (parsedJson['offers'] as List).isNotEmpty ? parsedJson['offers'][0] : "";

    return Restaurant(
        parsedJson['merchant_id'],
        parsedJson['restaurant_name'],
        parsedJson['delivery_est'],
        Rating.fromJson(parsedJson['ratings']),
        parsedJson['logo'],
        parsedJson['cuisine'],
        "",
        parsedJson['is_open'] == "open" ? true : false,
        discountTitle: promoTitle,
        discountDescription: "");
  }

  factory Restaurant.fromSearch(Map<String, dynamic> parsedJson) {
    var offers = parsedJson['offers'] as List;
    var searchFoods = parsedJson['item'] as List;
    List<Food> foods = searchFoods.map((i) {
      return Food.fromJson(i);
    }).toList();

    return Restaurant(
        parsedJson['merchant_id'],
        parsedJson['restaurant_name'],
        parsedJson['delivery_estimation'],
        Rating.fromJson(parsedJson['ratings']),
        parsedJson['logo'],
        parsedJson['cuisine'],
        parsedJson['address'],
        parsedJson['is_open'] == "open" ? true : false,
        discountTitle: offers.isNotEmpty ? offers[0] : null,
        discountDescription: offers.isNotEmpty ? offers[0] : null,
        searchFoodList: foods);
  }
}
