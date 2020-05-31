import 'package:flyereats/classes/data_provider.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/restaurant.dart';

class DataRepository {
  DataProvider _provider = DataProvider();

  Future<List<Location>> getLocations(String countryId) async {
    final response = await _provider.getLocations(countryId);
    var listLocations = response as List;
    List<Location> locations = listLocations.map((i) {
      return Location.fromJson(i);
    }).toList();
    return locations;
  }

  Future<List<Restaurant>> getRestaurantList(String address) async {
    final response = await _provider.getRestaurantList(address);
    if (response['code'] == 1) {
      var listLocations = response['details']['data'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();
      return restaurants;
    } else {
      return List();
    }
  }

  Future<List<Restaurant>> getRestaurantTop(String address) async {
    final response = await _provider.getRestaurantTop(address);
    if (response['code'] == 1) {
      var listLocations = response['details']['data'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();
      return restaurants;
    } else {
      return List();
    }
  }

  Future<List<MenuCategory>> getCategories(String restaurantId) async {
    final response = await _provider.getCategory(restaurantId);
    if (response['code'] == 1) {
      var list = response['details']['menu_category'] as List;
      List<MenuCategory> categories = list.map((i) {
        return MenuCategory.fromJson(i);
      }).toList();
      return categories;
    } else {
      return List();
    }
  }

  Future<List<Food>> getFoods(String restaurantId, String categoryId) async {
    final response = await _provider.getFoods(restaurantId, categoryId);
    if (response['code'] == 1) {
      var list = response['details']['item'] as List;
      List<Food> categories = list.map((i) {
        return Food.fromJson(i);
      }).toList();
      return categories;
    } else {
      return List();
    }
  }
}
