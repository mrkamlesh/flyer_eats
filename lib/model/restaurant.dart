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
  final List<String> offers;
  final List<String> badges;
  final String voucherBadge;
  final bool isOpen;
  final String currencyCode;
  final bool isBusy;
  final String isBusyMessage;
  final bool isOrderDisabled;

  final List<Food> searchFoodList;

  Restaurant(this.id, this.name, this.deliveryEstimation, this.rating,
      this.image, this.cuisine, this.address, this.isOpen, this.currencyCode,
      {this.offers,
      this.badges,
      this.voucherBadge,
      this.searchFoodList,
      this.isBusy,
      this.isBusyMessage,
      this.isOrderDisabled});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    var offers = parsedJson['offers'] as List;
    var badges = parsedJson['badges'] as List;

    return Restaurant(
        parsedJson['merchant_id'],
        parsedJson['restaurant_name'],
        parsedJson['delivery_estimation'],
        Rating.fromJson(parsedJson['ratings']),
        parsedJson['logo'],
        parsedJson['cuisine'],
        parsedJson['address'],
        parsedJson['is_open'] == "open" ? true : false,
        parsedJson['currency_code'],
        badges: badges.map((e) {
          return (e as String);
        }).toList(),
        offers: offers.map((e) {
          return (e as String);
        }).toList(),
        voucherBadge: parsedJson['voucher_badge'],
        isBusy: parsedJson['is_busy'],
        isBusyMessage: parsedJson['is_busy_message'],
        isOrderDisabled: parsedJson['disabled_ordering']);
  }

  factory Restaurant.fromSearch(Map<String, dynamic> parsedJson) {
    var offers = parsedJson['offers'] as List;
    var badges = parsedJson['badges'] as List;

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
        parsedJson['currency_code'],
        badges: badges.map((e) {
          return (e as String);
        }).toList(),
        offers: offers.map((e) {
          return (e as String);
        }).toList(),
        voucherBadge: parsedJson['voucher_badge'],
        isOrderDisabled: parsedJson['disabled_ordering'],
        searchFoodList: foods);
  }
}
