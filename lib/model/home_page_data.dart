import 'package:flyereats/model/ads.dart';
import 'package:flyereats/model/food_category.dart';
import 'package:flyereats/model/promo.dart';
import 'package:flyereats/model/restaurant.dart';

class HomePageData {
  final String location;
  final String countryId;
  final List<Promo> promos;
  final List<Restaurant> topRestaurants;
  final List<FoodCategory> categories;
  final List<Restaurant> dblRestaurants;
  final List<Restaurant> orderAgainRestaurants;
  final List<Ads> ads;

  HomePageData(
      {this.location,
      this.countryId,
      this.promos,
      this.topRestaurants,
      this.categories,
      this.dblRestaurants,
      this.orderAgainRestaurants,
      this.ads});

  factory HomePageData.fromJson(Map<String, dynamic> parsedJson) {
    var listPromos = parsedJson['offers'] as List;
    List<Promo> promos = listPromos.map((i) {
      return Promo.fromJson(i);
    }).toList();

    var listTopRestaurant = parsedJson['top_restaurants'] as List;
    List<Restaurant> top = listTopRestaurant.map((i) {
      return Restaurant.fromJsonTopRestaurant(i);
    }).toList();

    var listFoodCategories = parsedJson['foodCategories'] as List;
    List<FoodCategory> foodCategories = listFoodCategories.map((i) {
      return FoodCategory.fromJson(i);
    }).toList();

    var listDBLRestaurant = parsedJson['dblRestaurants'] as List;
    List<Restaurant> dblRestaurant = listDBLRestaurant.map((i) {
      return Restaurant.fromJsonDblRestaurant(i);
    }).toList();

    var listOrderAgainRestaurant = parsedJson['previousOrders'] as List;
    List<Restaurant> orderAgainRestaurant = listOrderAgainRestaurant.map((i) {
      return Restaurant.fromJsonOrderAgain(i);
    }).toList();

    var listAds = parsedJson['ads'] as List;
    List<Ads> ads = listAds.map((i) {
      return Ads.fromJson(i);
    }).toList();

    return HomePageData(
        location: parsedJson['location']['address'],
        countryId: parsedJson['location']['country_code'],
        promos: promos,
        topRestaurants: top,
        categories: foodCategories,
        dblRestaurants: dblRestaurant,
        orderAgainRestaurants: orderAgainRestaurant,
        ads: ads);
  }
}
