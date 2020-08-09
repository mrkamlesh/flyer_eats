import 'package:clients/classes/data_provider.dart';
import 'package:clients/model/ads.dart';
import 'package:clients/model/bank.dart';
import 'package:clients/model/current_order.dart';
import 'package:clients/model/detail_order.dart';
import 'package:clients/model/fe_offer.dart';
import 'package:clients/model/filter.dart';
import 'package:clients/model/food.dart';
import 'package:clients/model/food_detail.dart';
import 'package:clients/model/home_page_data.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/login_status.dart';
import 'package:clients/model/menu_category.dart';
import 'package:clients/model/notification.dart';
import 'package:clients/model/order.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/place_order_pickup.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/review.dart';
import 'package:clients/model/scratch_card.dart';
import 'package:clients/model/sort_by.dart';
import 'package:clients/model/user.dart';
import 'package:clients/model/user_profile.dart';
import 'package:clients/model/voucher.dart';
import 'package:clients/model/register_post.dart';
import 'package:clients/model/wallet.dart';
import 'package:clients/page/restaurants_list_page.dart';

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
      PlaceOrder placeOrder = PlaceOrder(
          id: response['details']['order_id'], message: response['msg']);
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

  Future<LoginStatus> loginByEmail(String email, String password) async {
    final response = await _provider.loginByEmail(email, password);
    if (response['code'] == 1) {
      return LoginStatus(response['msg'], true);
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<LoginStatus> forgotPassword(String email) async {
    final response = await _provider.forgotPassword(email);
    if (response['code'] == 1) {
      return LoginStatus(response['msg'], true);
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<dynamic> verifyOtp(String contactPhone, String otp,
      String firebaseToken, String platform, String version) async {
    final response = await _provider.verifyOtp(
        contactPhone, otp, firebaseToken, platform, version);
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

  Future<List<Order>> getOrderHistory(
      String token, String typeOrder, int page) async {
    final response = await _provider.getOrderHistory(token, typeOrder, 0);
    if (response['code'] == 1) {
      var orderHistory = response['details'] as List;
      List<Order> list = orderHistory.map((i) {
        return Order.fromJson(i);
      }).toList();
      return list;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<List<PickupOrder>> getPickupOrderHistory(
      String token, String typeOrder, int page) async {
    final response = await _provider.getOrderHistory(token, typeOrder, page);
    if (response['code'] == 1) {
      var orderHistory = response['details'] as List;
      List<PickupOrder> list = orderHistory.map((i) {
        return PickupOrder.fromJson(i);
      }).toList();
      return list;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<List<Restaurant>> globalSearch(
      String token, String textSearch, String address, int page) async {
    final response =
        await _provider.globalSearch(token, textSearch, address, page);
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

  Future<List<NotificationItem>> getNotificationList(
      String token, int page) async {
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

  Future<dynamic> checkTokenValid(String token, String firebaseToken,
      String platform, String version) async {
    final response = await _provider.checkTokenValid(
        token, firebaseToken, platform, version);
    if (response['details']['is_exist']) {
      User user = User.fromJson(response['details']);
      return user;
    } else {
      return response['msg'];
    }
  }

  Future<dynamic> saveProfile(String token, Profile profile) async {
    final response = await _provider.saveProfile(token, profile);
    if (response['code'] == 1) {
      User user = User.fromJson(response['details']);
      return user;
    } else {
      return response['msg'];
    }
  }

  Future<bool> addReview(
      String token, String orderId, String review, double rating) async {
    final response = await _provider.addReview(token, orderId, review, rating);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<FEOffer>> getFEOfferList(String token, String address) async {
    final response = await _provider.getOfferList(token, address, "admin");
    if (response['code'] == 1) {
      var listResponse = response['details'] as List;
      List<FEOffer> list = listResponse.map((i) {
        return FEOffer.fromJson(i);
      }).toList();
      return list;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<List<Restaurant>> getMerchantOfferList(
      String token, String address) async {
    final response = await _provider.getOfferList(token, address, "merchant");
    if (response['code'] == 1) {
      var listResponse = response['details'] as List;
      List<Restaurant> list = listResponse.map((i) {
        return Restaurant.fromJson(i['merchantInfo']);
      }).toList();
      return list;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<List<Bank>> getBankOfferList(String token, String address) async {
    final response = await _provider.getOfferList(token, address, "bank");
    if (response['code'] == 1) {
      var listResponse = response['details'] as List;
      List<Bank> list = listResponse.map((i) {
        return Bank.fromJson(i);
      }).toList();
      return list;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<Map<String, dynamic>> getPickupInfo(
      String token, String address) async {
    final response = await _provider.getPickupInfo(token, address);
    if (response['code'] == 1) {
      Map<String, dynamic> map = Map();
      map['description'] = response['details']['description'];
      map['top_description'] = response['details']['top_description'];
      return map;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<bool> saveToken(String token) async {
    await _provider.saveToken(token);
    return true;
  }

  Future<String> getSavedToken() async {
    return await _provider.getSavedToken();
  }

  Future<bool> saveAddress(String address) async {
    await _provider.saveAddress(address);
    return true;
  }

  Future<String> getSavedAddress() async {
    return await _provider.getSavedAddress();
  }

  Future<bool> removeData() async {
    return await _provider.removeData();
  }

  Future<List<Location>> getLocations(String countryId) async {
    final response = await _provider.getLocations(countryId);
    var listLocations = response as List;
    List<Location> locations = listLocations.map((i) {
      return Location.fromJson(i);
    }).toList();
    return locations;
  }

  Future<Location> getPredefinedLocationByLatLng(double lat, double lng) async {
    final response = await _provider.getPredefinedLocationByLatLng(lat, lng);
    if (response['code'] == 1) {
      if ((response['details'] as Map).containsKey('address')) {
        return Location.fromHomePageJson(response['details']);
      }
    }
    return null;
  }

  Future<List<Voucher>> getCoupons(String restaurantId, String token) async {
    final response = await _provider.getCoupons(restaurantId, token);
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

  Future<PlaceOrderPickup> getDeliveryCharge(
      String token,
      String deliveryLat,
      String deliveryLng,
      String pickupLat,
      String pickupLng,
      String location) async {
    final response = await _provider.getDeliveryCharge(
        token, deliveryLat, deliveryLng, pickupLat, pickupLng, location);
    if (response['code'] == 1) {
      return PlaceOrderPickup(
          isValid: true,
          razorSecret: response['details']['razor_secret'],
          razorKey: response['details']['razor_key'],
          distance: response['details']['distance'].toString(),
          deliveryAmount:
              double.parse(response['details']['price'].toString()));
    } else {
      return PlaceOrderPickup(isValid: false, message: response['msg']);
    }
  }

  Future<String> placeOrderPickup(PlaceOrderPickup placeOrderPickup) async {
    final response = await _provider.placeOrderPickup(placeOrderPickup);
    if (response['code'] == 1) {
      return response['details']['order_id'];
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<dynamic> applyVoucher(String restaurantId, String voucherCode,
      double totalOrder, String token) async {
    final response = await _provider.applyCoupon(
        restaurantId, voucherCode, totalOrder, token);
    if (response['code'] == 1) {
      Voucher voucher = Voucher.fromJson(response['details']);
      return voucher;
    } else {
      return response['msg'] as String;
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
      int adsPage,
      String time}) async {
    final response = await _provider.getHomePageData(
        address: address,
        adsPage: adsPage,
        dblPage: dblPage,
        foodCategoryPage: foodCategoryPage,
        lat: lat,
        long: long,
        token: token,
        topRestaurantPage: topRestaurantPage,
        time: time);
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
        address: address,
        adsPage: 0,
        dblPage: 0,
        foodCategoryPage: 0,
        token: token,
        topRestaurantPage: 0);
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

  Future<bool> scratchCard(String token, String cardId) async {
    final response = await _provider.scratchCard(token, cardId);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<Wallet> getWalletInfo(String token) async {
    final response = await _provider.getWalletInfo(token);
    if (response['code'] == 1) {
      Wallet wallet = Wallet.fromJson(response['details']);
      return wallet;
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<bool> addWallet(String token, double amount) async {
    final response = await _provider.addWallet(token, amount);
    if (response['code'] == 1) {
      return true;
    } else {
      return false;
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

  Future<dynamic> getPickupDetailOrder(String orderId, String token) async {
    final response = await _provider.getPickupOrderDetail(orderId, token);
    if (response['code'] == 1) {
      PickupDetailOrder detailOrder =
          PickupDetailOrder.fromJson(response['details']);
      return detailOrder;
    } else {
      return response['msg'];
    }
  }

  Future<Map<String, dynamic>> getFirstDataRestaurantList(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category,
      bool isVegOnly,
      {String cuisineType,
      String sortBy}) async {
    Map<String, dynamic> map = Map();

    final response = await _provider.getRestaurantList(
        token, address, merchantType, type, category, 0, isVegOnly,
        sortBy: sortBy, cuisineType: cuisineType);
    if (response['code'] == 1) {
      var listLocations = response['details']['restaurants'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();

      restaurants.sort((a, b) {
        if (a.isOpen) {
          return -1;
        }
        return 1;
      });

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

      if ((response['details']['filteroptions'] is Map)) {
        var listFilter = response['details']['filteroptions']['cuisine_type']
            ['options'] as List;
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

  Future<List<Restaurant>> getRestaurantList(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category,
      int page,
      bool isVegOnly) async {
    final response = await _provider.getRestaurantList(
        token, address, merchantType, type, category, page, isVegOnly);
    if (response['code'] == 1) {
      var listLocations = response['details']['restaurants'] as List;
      List<Restaurant> restaurants = listLocations.map((i) {
        return Restaurant.fromJson(i);
      }).toList();

      restaurants.sort((a, b) {
        if (a.isOpen) {
          return -1;
        }
        return 1;
      });

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

  Future<List<Food>> getFoods(String restaurantId, String categoryId,
      bool isVegOnly, String searchKeyword) async {
    final response = await _provider.getFoods(
        restaurantId, categoryId, isVegOnly, searchKeyword);
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

  Future<dynamic> getFoodDetail(String foodId) async {
    final response = await _provider.getFoodDetail(foodId);
    if (response['code'] == 1) {
      FoodDetail foodDetail = FoodDetail.fromJson(response['details']);
      return foodDetail;
    } else {
      return response['msg'];
    }
  }

  Future<CurrentOrder> getActiveOrder(String token) async {
    final response = await _provider.getActiveOrder(token);
    if (response['code'] == 1) {
      if (response['details'] != "") {
        CurrentOrder currentOrder = CurrentOrder.fromJson(response);
        return currentOrder;
      } else {
        CurrentOrder currentOrder = CurrentOrder(isActive: false);
        return currentOrder;
      }
    } else {
      throw Exception(response['msg']);
    }
  }

  Future<dynamic> getSimilarRestaurant(
      String token, String merchantId, String address) async {
    final response =
        await _provider.getSimilarRestaurant(token, merchantId, address);
    if (response['code'] == 1) {
      Map<String, dynamic> map = Map();
      map['category'] = response['details']['food_category_id'];
      var listResponse = response['details']['restaurants'] as List;
      List<Restaurant> list = listResponse.map((i) {
        return Restaurant.fromJson(i);
      }).toList();
      map['restaurants'] = list;
      return map;
    } else {
      return response['msg'];
    }
  }

  Future<Map<String, dynamic>> getScratchCardList(String token) async {
    final response = await _provider.getScratchCardList(token);
    if (response['code'] == 1) {
      Map<String, dynamic> map = Map();
      map['amount'] = response['details']['total_amount'].toString();
      map['currency_code'] = response['details']['currency_code'];
      var listScratched = response['details']['scratched_card'] as List;
      var listNotScratched = response['details']['not_scratched_card'] as List;
      List<ScratchCard> cards = listNotScratched.map((i) {
            return ScratchCard.fromListJson(i);
          }).toList() +
          listScratched.map((i) {
            return ScratchCard.fromListJson(i);
          }).toList();
      map['list'] = cards;
      return map;
    } else {
      Map<String, dynamic> map = Map();
      map['meesage'] = response['msg'];
      return map;
    }
  }
}
