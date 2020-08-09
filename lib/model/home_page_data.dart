import 'package:clients/model/ads.dart';
import 'package:clients/model/food_category.dart';
import 'package:clients/model/banner.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/restaurant.dart';

class HomePageData {
  final Location location;
  final String countryId;
  final List<BannerItem> promos;
  final List<Restaurant> topRestaurants;
  final List<FoodCategory> categories;
  final List<Restaurant> dblRestaurants;
  final List<Restaurant> orderAgainRestaurants;
  final List<Ads> ads;
  final String referralCode;
  final String referralDiscount;
  final String currencyCode;
  final String dblText;

  HomePageData({
    this.location,
    this.countryId,
    this.promos,
    this.topRestaurants,
    this.categories,
    this.dblRestaurants,
    this.orderAgainRestaurants,
    this.ads,
    this.referralCode,
    this.referralDiscount,
    this.currencyCode,
    this.dblText,
  });

  factory HomePageData.fromJson(Map<String, dynamic> parsedJson) {
    var listPromos = parsedJson['offers'] as List;
    List<BannerItem> promos = listPromos.map((i) {
      return BannerItem.fromJson(i);
    }).toList();

    var listTopRestaurant = parsedJson['top_restaurants'] as List;
    List<Restaurant> top = listTopRestaurant.map((i) {
      return Restaurant.fromJson(i);
    }).toList();

    var listFoodCategories = parsedJson['foodCategories'] as List;
    List<FoodCategory> foodCategories = listFoodCategories.map((i) {
      return FoodCategory.fromJson(i);
    }).toList();

    var listDBLRestaurant = parsedJson['dblRestaurants'] as List;
    List<Restaurant> dblRestaurant = listDBLRestaurant.map((i) {
      return Restaurant.fromJson(i);
    }).toList();

    var listOrderAgainRestaurant = parsedJson['previousOrders'] as List;
    List<Restaurant> orderAgainRestaurant = listOrderAgainRestaurant.map((i) {
      return Restaurant.fromJson(i);
    }).toList();

    var listAds = parsedJson['ads'] as List;
    List<Ads> ads = listAds.map((i) {
      return Ads.fromJson(i);
    }).toList();

    return HomePageData(
        location: Location.fromHomePageJson(parsedJson['location']),
        countryId: parsedJson['location']['country_code'],
        referralDiscount: parsedJson['referral_discount'].toString(),
        referralCode: parsedJson['referral_code'],
        dblText: parsedJson['dinner_section_title'],
        currencyCode: parsedJson['currency_code'],
        promos: promos,
        topRestaurants: top,
        categories: foodCategories,
        dblRestaurants: dblRestaurant,
        orderAgainRestaurants: orderAgainRestaurant,
        ads: ads);
  }
}
