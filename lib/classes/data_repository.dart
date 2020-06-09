import 'package:flyereats/classes/data_provider.dart';
import 'package:flyereats/model/filter.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/sort_by.dart';
import 'package:flyereats/model/user.dart';

class DataRepository {
  DataProvider _provider = DataProvider();

  Future<User> loginWithEmail(String email, String password) async {
    final response = await _provider.loginWithEmail(email, password);
    if (response['code'] == 1) {
      return User.fromJson(response['details'], email, password);
    } else {
      return null;
    }
  }

  Future<bool> saveLoginInformation(String email, String password) async {
    await _provider.saveLoginInformation(email, password);
    return true;
  }

  Future<Map<String, String>> getLoginInformation() async {
    return await _provider.getLoginInformation();
  }

  Future<List<Location>> getLocations(String countryId) async {
    final response = await _provider.getLocations(countryId);
    var listLocations = response as List;
    List<Location> locations = listLocations.map((i) {
      return Location.fromJson(i);
    }).toList();
    return locations;
  }

  Future<Location> getLocationByLatLng(double lat, double lng) async {
    final response = await _provider.getLocationByLatLng(lat, lng);
    if (response['code'] == 1) {
      var locationMap = response['details'];
      Location location = Location.fromJson2(locationMap);
      return location;
    } else {
      return null;
    }
  }

  Future<List<Restaurant>> getRestaurantList(String address, int page) async {
    final response = await _provider.getRestaurantList(address, page);
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

  Future<Map<String, dynamic>> getFirstDataRestaurantList(String address,
      {String cuisineType, String sortBy}) async {
    Map<String, dynamic> map = Map();

    final response = await _provider.getRestaurantList(address, 0,
        sortBy: sortBy, cuisineType: cuisineType);
    if (response['code'] == 1) {
      var listLocations = response['details']['data'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();

      map['restaurants'] = restaurants;

      var listSortBY = response['details']['sortoptions'];
      List<SortBy> sortBy = List();
      sortBy.add(SortBy(
          key: listSortBY['sort_ratings']['key'],
          title: listSortBY['sort_ratings']['title']));
      sortBy.add(SortBy(
          key: listSortBY['sort_recommended']['key'],
          title: listSortBY['sort_recommended']['title']));
      sortBy.add(SortBy(
          key: listSortBY['sort_distance']['key'],
          title: listSortBY['sort_distance']['title']));
      map['sortBy'] = sortBy;

      var listFilter = response['details']['filteroptions']['cuisine_type']
          ['options'] as List;
      List<Filter> filters = listFilter.map((i) {
        return Filter.fromJson(i);
      }).toList();
      map['filters'] = filters;

      return map;
    } else {
      return Map();
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
