import 'package:flyereats/classes/data_provider.dart';
import 'package:flyereats/model/ads.dart';
import 'package:flyereats/model/current_order.dart';
import 'package:flyereats/model/detail_order.dart';
import 'package:flyereats/model/filter.dart';
import 'package:flyereats/model/food.dart';
import 'package:flyereats/model/home_page_data.dart';
import 'package:flyereats/model/location.dart';
import 'package:flyereats/model/login_status.dart';
import 'package:flyereats/model/menu_category.dart';
import 'package:flyereats/model/notification.dart';
import 'package:flyereats/model/order.dart';
import 'package:flyereats/model/place_order.dart';
import 'package:flyereats/model/restaurant.dart';
import 'package:flyereats/model/review.dart';
import 'package:flyereats/model/sort_by.dart';
import 'package:flyereats/model/user.dart';
import 'package:flyereats/model/voucher.dart';
import 'package:flyereats/model/register_post.dart';
import 'package:flyereats/page/restaurants_list_page.dart';

class DataRepository {
  DataProvider _provider = DataProvider();

  Future<PlaceOrder> getPaymentOptions(PlaceOrder placeOrder) async {
    final response = await _provider.getPaymentOptions(placeOrder);
    if (response['code'] == 1) {
      PlaceOrder placeOrder = PlaceOrder.fromJson(response);
      return placeOrder;
    } else {
      return PlaceOrder(isValid: false, message: response['msg']);
    }
  }

  Future<PlaceOrder> placeOrder(PlaceOrder placeOrder) async {
    final response = await _provider.placeOrder(placeOrder);
    if (response['code'] == 1) {
      PlaceOrder placeOrder = PlaceOrder(id: response['details']['order_id'], message: response['msg']);
      return placeOrder;
    } else {
      return PlaceOrder(isValid: false, message: response['msg']);
    }
  }

  Future<LoginStatus> checkPhoneExist(String contactPhone) async {
    final response = await _provider.checkPhoneExist(contactPhone);
    if (response['code'] == 1) {
      if (response['details']['is_exist'])
        return LoginStatus(response['msg'], true);
      else {
        return LoginStatus(response['msg'], false);
      }
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<LoginStatus> checkEmailExist(String email) async {
    final response = await _provider.checkEmailExist(email);
    if (response['code'] == 1) {
      if (response['details']['is_exist'])
        return LoginStatus(response['msg'], true);
      else
        return LoginStatus(response['msg'], false);
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<dynamic> verifyOtp(String contactPhone, String otp) async {
    final response = await _provider.verifyOtp(contactPhone, otp);
    if (response['code'] == 1) {
      User user = User.fromJson(response['details']);
      return user;
    } else {
      return response['msg'];
    }
  }

  Future<LoginStatus> register(RegisterPost registerPost) async {
    final response = await _provider.register(registerPost);
    if (response['code'] == 1) {
      return LoginStatus(response['msg'], true);
    } else {
      return LoginStatus(response['msg'], false);
    }
  }

  Future<LoginStatus> loginWithSocialMedia(
      {String userId,
      String email,
      String provider,
      String fullName,
      String imageUrl,
      String deviceId,
      String devicePlatform,
      String appVersion,
      String contactPhone}) async {
    final response = await _provider.loginWithSocialMedia(
        email: email,
        appVersion: appVersion,
        contactPhone: contactPhone,
        deviceId: deviceId,
        devicePlatform: devicePlatform,
        fullName: fullName,
        imageUrl: imageUrl,
        provider: provider,
        userId: userId);
    if (response['code'] == 1) {
      return LoginStatus(response['msg'], true);
    } else {
      return LoginStatus(response['msg'], false);
    }
  }

  Future<List<Order>> getOrderHistory(String token) async {
    final response = await _provider.getOrderHistory(token);
    if (response['code'] == 1) {
      var orderHistory = response['details'] as List;
      List<Order> list = orderHistory.map((i) {
        return Order.fromJson(i);
      }).toList();
      return list;
    } else {
      return List();
    }
  }

  Future<List<Restaurant>> globalSearch(String token, String textSearch, String address, int page) async {
    final response = await _provider.globalSearch(token, textSearch, address, page);
    if (response['code'] == 1) {
      var listResponse = response['details'] as List;
      List<Restaurant> list = listResponse.map((i) {
        return Restaurant.fromSearch(i);
      }).toList();
      return list;
    } else {
      return List();
    }
  }

  Future<List<NotificationItem>> getNotificationList(String token, int page) async {
    final response = await _provider.getNotificationList(token, page);
    if (response['code'] == 1) {
      var listResponse = response['details']['data'] as List;
      List<NotificationItem> list = listResponse.map((i) {
        return NotificationItem.fromJson(i);
      }).toList();
      return list;
    } else {
      return List();
    }
  }

  Future<List<Review>> getReview(String restaurantId, String token) async {
    final response = await _provider.getReview(restaurantId, token);
    if (response['code'] == 1) {
      var listResponse = response['details'] as List;
      List<Review> list = listResponse.map((i) {
        return Review.fromJson(i);
      }).toList();
      return list;
    } else {
      return List();
    }
  }

/*  Future<User> loginWithEmail(String email, String password) async {
    final response = await _provider.loginWithEmail(email, password);
    if (response['code'] == 1) {
      return User.fromJson(response['details'], email, password);
    } else {
      return null;
    }
  }*/

  Future<List<String>> getRegisterLocations() async {
    final response = await _provider.getRegisterLocations();
    if (response['code'] == 1) {
      List<String> list = List();
      Map<String, dynamic> responseList = response['details']['locations'];
      responseList.keys.forEach((element) {
        list.add(element);
      });
      return list;
    } else {
      return List();
    }
  }

  Future<dynamic> checkTokenValid(String token) async {
    final response = await _provider.checkTokenValid(token);
    if (response['details']['is_exist']) {
      User user = User.fromJson(response['details']);
      return user;
    } else {
      return response['msg'];
    }
  }

  Future<bool> addReview(String token, String orderId, String review, double rating) async {
    final response = await _provider.addReview(token, orderId, review, rating);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveToken(String token) async {
    await _provider.saveToken(token);
    return true;
  }

  Future<String> getSavedToken() async {
    return await _provider.getSavedToken();
  }

  Future<List<Location>> getLocations(String countryId) async {
    final response = await _provider.getLocations(countryId);
    var listLocations = response as List;
    List<Location> locations = listLocations.map((i) {
      return Location.fromJson(i);
    }).toList();
    return locations;
  }

  Future<List<Voucher>> getPromos(String restaurantId, String token) async {
    final response = await _provider.getPromos(restaurantId, token);
    if (response['code'] == 1) {
      var listResponse = response['details']['promos'] as List;
      List<Voucher> list = listResponse.map((e) {
        return Voucher.fromJson2(e);
      }).toList();
      //list.add(response['details']['free_delivery']);
      return list;
    } else {
      return null;
    }
  }

  Future<dynamic> applyVoucher(String restaurantId, String voucherCode, double totalOrder, String token) async {
    final response = await _provider.applyCoupon(restaurantId, voucherCode, totalOrder, token);
    if (response['code'] == 1) {
      Voucher voucher = Voucher.fromJson(response['details']);
      return voucher;
    } else {
      return response['msg'] as String;
    }
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

  Future<dynamic> getHomePageData(
      {String token,
      String address,
      double lat,
      double long,
      int topRestaurantPage,
      int dblPage,
      int foodCategoryPage,
      int adsPage}) async {
    final response = await _provider.getHomePageData(
        address: address,
        adsPage: adsPage,
        dblPage: dblPage,
        foodCategoryPage: foodCategoryPage,
        lat: lat,
        long: long,
        token: token,
        topRestaurantPage: topRestaurantPage);
    if (response['code'] == 1) {
      var homePageMap = response['details'];
      HomePageData data = HomePageData.fromJson(homePageMap);
      return data;
    } else {
      return response['msg'];
    }
  }

  Future<dynamic> getAds(String token, String address) async {
    final response = await _provider.getHomePageData(
        address: address, adsPage: 0, dblPage: 0, foodCategoryPage: 0, token: token, topRestaurantPage: 0);
    if (response['code'] == 1) {
      var listAds = response['details']['ads'] as List;
      List<Ads> ads = listAds.map((i) {
        return Ads.fromJson(i);
      }).toList();
      return ads;
    } else {
      return response['msg'];
    }
  }

  Future<dynamic> getDetailOrder(String orderId, String token) async {
    final response = await _provider.getOrderDetail(orderId, token);
    if (response['code'] == 1) {
      DetailOrder detailOrder = DetailOrder.fromJson(response['details']);
      return detailOrder;
    } else {
      return response['msg'];
    }
  }

  Future<Map<String, dynamic>> getFirstDataRestaurantList(
      String token, String address, MerchantType merchantType, RestaurantListType type, String category,
      {String cuisineType, String sortBy}) async {
    Map<String, dynamic> map = Map();

    final response = await _provider.getRestaurantList(token, address, merchantType, type, category, 0,
        sortBy: sortBy, cuisineType: cuisineType);
    if (response['code'] == 1) {
      var listLocations = response['details']['restaurants'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();

      map['restaurants'] = restaurants;

      var listSortBY = response['details']['sortoptions'];
      List<SortBy> sortBy = List();
      sortBy.add(SortBy(key: listSortBY['sort_ratings']['key'], title: listSortBY['sort_ratings']['title']));
      sortBy.add(SortBy(key: listSortBY['sort_recommended']['key'], title: listSortBY['sort_recommended']['title']));
      sortBy.add(SortBy(key: listSortBY['sort_distance']['key'], title: listSortBY['sort_distance']['title']));
      map['sortBy'] = sortBy;

      if ((response['details']['filteroptions'] is Map)) {
        var listFilter = response['details']['filteroptions']['cuisine_type']['options'] as List;
        List<Filter> filters = listFilter.map((i) {
          return Filter.fromJson(i);
        }).toList();
        map['filters'] = filters;
      } else {
        map['filters'] = List<Filter>();
      }

      return map;
    } else {
      return Map();
    }
  }

  Future<List<Restaurant>> getRestaurantList(String token, String address, MerchantType merchantType,
      RestaurantListType type, String category, int page) async {
    final response = await _provider.getRestaurantList(token, address, merchantType, type, category, page);
    if (response['code'] == 1) {
      var listLocations = response['details']['restaurants'] as List;
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
      List<Food> foods = list.map((i) {
        return Food.fromJson(i);
      }).toList();
      return foods;
    } else {
      return List();
    }
  }

  Future<CurrentOrder> getActiveOrder(String token) async {
    final response = await _provider.getActiveOrder(token);
    if (response['code'] == 1) {
      CurrentOrder currentOrder = CurrentOrder.fromJson(response);
      return currentOrder;
    } else {
      throw Exception(response['msg']);
    }
  }
}
