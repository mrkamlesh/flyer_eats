import 'dart:io';

import 'package:clients/model/place_order_pickup.dart';
import 'package:dio/dio.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/model/place_order.dart';
import 'package:clients/model/user_profile.dart';
import 'package:clients/page/restaurants_list_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clients/model/register_post.dart';

class DataProvider {
  static String emailKey = "EMAIL";
  static String passwordKey = "PASSWORD";

  //String serverUrl = "https://www.pollachiarea.com/flyereats/";

  String serverUrl = "http://flyereats.in/";

  Future<dynamic> checkPhoneExist(
      String contactPhone, String otpSignature) async {
    String url =
        "${serverUrl}mobileapp/apiRest/checkMobileExist?json=true&api_key=flyereats";

    var formData = {
      "contact_phone": contactPhone,
      "otp_signature": otpSignature
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> register(
      RegisterPost registerPost, String otpSignature) async {
    String url =
        "${serverUrl}mobileapp/apiRest/register?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "email_address": registerPost.email,
      "contact_phone": registerPost.contactPhone,
      "referral_code": registerPost.isUseReferral ? registerPost.referral : "",
      "full_name": registerPost.name,
      "country_code": registerPost.countryId,
      "loc_name": registerPost.location.location,
      "device_id": registerPost.deviceId,
      "app_version": registerPost.appVersion,
      "device_platform": registerPost.devicePlatform,
      "otp_signature": otpSignature
    };

    if (registerPost.avatar != null) {
      formData['file'] = await MultipartFile.fromFile(registerPost.avatar.path);
    } else {
      if (registerPost.imageUrl != null && registerPost.imageUrl != "") {
        formData['image_url'] = registerPost.imageUrl;
      }
    }

    var responseJson;
    try {
      final response = await Dio().post(url,
          data: FormData.fromMap(formData),
          options: Options(contentType: 'JSON'));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> loginWithSocialMedia(
      {String userId,
      String email,
      String provider,
      String fullName,
      String imageUrl,
      String deviceId,
      String devicePlatform,
      String appVersion,
      String contactPhone}) async {
    String url =
        "${serverUrl}mobileapp/apiRest/socialLogin?json=true&api_key=flyereats";

    var formData = {
      "userid": userId,
      "email": email,
      "provider": provider,
      "full_name": fullName,
      "imageurl": imageUrl,
      "device_id": deviceId,
      "device_platform": devicePlatform,
      "app_version": appVersion,
      "contact_phone": contactPhone,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> checkEmailExist(String email) async {
    String url =
        "${serverUrl}mobileapp/apiRest/checkEmailExist?json=true&api_key=flyereats";

    var formData = {
      "email": email,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> loginByEmail(String contactPhone, String email,
      String password, String otpSignature) async {
    String url =
        "${serverUrl}mobileapp/apiRest/checkAccount?json=true&api_key=flyereats";

    var formData = {
      "contact_phone": contactPhone,
      "email_address": email,
      "password": password,
      "otp_signature": otpSignature
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> forgotPassword(String email) async {
    String url =
        "${serverUrl}mobileapp/apiRest/forgotPassword?json=true&api_key=flyereats&email_address=$email";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> verifyOtp(String contactPhone, String otp,
      String firebaseToken, String platform, String version) async {
    String url =
        "${serverUrl}mobileapp/apiRest/verifyOtp?json=true&api_key=flyereats";

    var formData = {
      "contact_phone": contactPhone,
      "code": otp,
      "device_id": firebaseToken,
      "device_platform": platform,
      "app_version": version
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getRegisterLocations() async {
    String url =
        "${serverUrl}mobileapp/apinew/getCustomFields?json=true&api_key=flyereats";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getPaymentOptions(PlaceOrder order) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getPaymentOptions?json=true&api_key=flyereats";

    var formData = {
      "next_step": "payment_option",
      "id": order.address.id,
      "formatted_address": order.address.address,
      "google_lat": order.address.latitude,
      "google_lng": order.address.longitude,
      "location_name": order.address.title,
      "contact_phone": order.contact,
      "delivery_instruction": order.deliveryInstruction,
      "address_id": order.address.id,
      "cart_subtotal": order.subTotal().toString(),
      "merchant_id": order.restaurant.id,
      "client_token": order.user.token,
      "transaction_type": order.transactionType,
      "cart": order.foodCart.cartToString(),
      "voucher_code": order.voucher.name ?? ""
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> placeOrder(PlaceOrder order) async {
    String url =
        "${serverUrl}mobileapp/apiRest/placeOrder?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "merchant_id": order.restaurant.id,
      "client_token": order.user.token,
      "transaction_type": order.transactionType,
      "cart": order.foodCart.cartToString(),
      "formatted_address": order.address.address,
      "google_lat": order.address.latitude,
      "google_lng": order.address.longitude,
      "next_step": "payment_option",
      "id": order.address.id,
      "location_name": order.address.title,
      "contact_phone": order.contact,
      "delivery_instruction": order.deliveryInstruction,
      "street": order.address.address,
      "address_id": order.address.id,
      "payment_list": order.selectedPaymentMethod,
      "voucher_code": order.voucher.name != null ? order.voucher.name : "",
      "voucher_amount":
          order.voucher.amount != 0 ? order.voucher.amount.toString() : "",
      "voucher_type": order.voucher.type != null ? order.voucher.type : "",
      "voucher_rate":
          order.voucher.rate != 0 ? order.voucher.rate.toString() : "",
      //"change_primary_contact": order.isChangePrimaryContact ? "1" : "0",
      "delivery_date": order.getDeliveryDate(), //yyyy-mm-dd
      "delivery_time": order.getDeliveryTime(),
    };

    if (order.getWalletUsed() > 0) {
      formData['wallet_amount'] = order.getWalletUsed().toString();
    }

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> requestOtpChangeContactPhone(
      String contactPhone,
      String otpSignature,
      bool isDefault,
      String token,
      bool isSaveProfile) async {
    String url =
        "${serverUrl}mobileapp/apiRest/sendOtp?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "contact_phone": contactPhone,
      "otp_signature": otpSignature,
      "is_default": isDefault ? "1" : "0",
      "save_profile": isSaveProfile ? "1" : "0",
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> verifyOtpChangeContactPhone(
      String contactPhone, String otpCode, bool isDefault, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/changeDefaultContact?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "contact_phone": contactPhone,
      "code": otpCode,
      "is_default": isDefault ? "1" : "0",
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getOrderDetail(String orderId, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getReceipt?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "order_id": orderId,
      //trans_type: delivery / pickup_drop determine food order or pickup order
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getPickupOrderDetail(String orderId, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getPickupOrderDetails?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "order_id": orderId,
      //trans_type: delivery / pickup_drop determine food order or pickup order
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getCoupons(String restaurantId, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/loadPromos?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "merchant_id": restaurantId,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getOrderHistory(
      String token, String typeOrder, int page) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getOrderHistory?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "type": typeOrder,
      "page": page.toString()
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> scratchCard(String token, String cardId) async {
    String url =
        "${serverUrl}mobileapp/apiRest/cardScratch?json=true&api_key=flyereats";

    var formData = {"client_token": token, "card_id": cardId};

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getDeliveryCharge(
      String token,
      String deliveryLat,
      String deliveryLng,
      String pickupLat,
      String pickupLng,
      String location) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getDeliveryCharge?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "google_lat": deliveryLat,
      "google_lng": deliveryLng,
      "pickup_lat": pickupLat,
      "pickup_long": pickupLng,
      "location": location,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> placeOrderPickup(PlaceOrderPickup placeOrderPickup) async {
    String url =
        "${serverUrl}mobileapp/apiRest/placePickupOrder?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "client_token": placeOrderPickup.token,
      "items": placeOrderPickup.pickUp.items.join(","),
      "formatted_address": placeOrderPickup.address.address,
      "google_lng": placeOrderPickup.address.longitude,
      "pickup_lat": placeOrderPickup.address.latitude,
      "location_name": placeOrderPickup.location,
      "contact_phone": placeOrderPickup.contact,
      "delivery_instruction": placeOrderPickup.pickUp.deliveryInstruction,
      "street": placeOrderPickup.address.address,
      /*"change_primary_contact":
          placeOrderPickup.isChangePrimaryContact ? "1" : "0",*/
      "pickup_address": placeOrderPickup.pickUp.shop.address,
      "shop_name": placeOrderPickup.pickUp.shop.name,
      "shop_description": placeOrderPickup.pickUp.shop.description,
      "pickup_latitude": placeOrderPickup.pickUp.shop.lat.toString(),
      "pickup_longitude": placeOrderPickup.pickUp.shop.long.toString(),
      "price": placeOrderPickup.deliveryAmount.toString(),
      "delivery_date": "",
      "delivery_time": "",
    };

    List files = [];

    for (int i = 0; i < placeOrderPickup.pickUp.attachment.length; i++) {
      files.add(await MultipartFile.fromFile(
          placeOrderPickup.pickUp.attachment[i].path));
    }

    formData['thumbnail_file'] = files;

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getScratchCardList(String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/scratchCardHistory?json=true&api_key=flyereats";

    var formData = {"client_token": token};

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
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
    String url =
        "${serverUrl}mobileapp/apiRest/homePage?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "client_token": token,
      "sponsor_page":
          topRestaurantPage != null ? topRestaurantPage.toString() : "0",
      "time_page": dblPage != null ? dblPage.toString() : "0",
      "category_page":
          foodCategoryPage != null ? foodCategoryPage.toString() : "0",
      "ads_page": adsPage != null ? adsPage.toString() : "0",
      "time": time,
    };

    if (lat != null && long != null) {
      formData["sslatlong"] = lat.toString() + "," + long.toString();
    }

    if (address != null && address != "") {
      formData["address"] = address;
    }

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getReview(String restaurantId, String token) async {
    String url = "${serverUrl}mobileapp/apinew/merchantReviews?json=true"
        "&merchant_id=$restaurantId"
        "&api_key=flyereats&client_token=$token";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> applyCoupon(String restaurantId, String voucherCode,
      double totalOrder, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/applyVoucher?json=true&api_key=flyereats";

    var formData = {
      "merchant_id": restaurantId,
      "voucher_code": voucherCode,
      "cart_sub_total": totalOrder.toString(),
      "client_token": token,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

/*  Future<dynamic> loginWithEmail(String email, String password) async {
    String url =
        "${productionServerUrl}mobileapp/apinew/login?json=true&next_steps=account&email_address=$email&password=$password&api_key=flyereats";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }*/

  Future<dynamic> addReview(
      String token, String orderId, String review, double rating) async {
    String url =
        "${serverUrl}mobileapp/apiRest/addReview?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "order_id": orderId,
      "rating": rating.toString(),
      "review": review,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> checkTokenValid(String token, String firebaseToken,
      String platform, String version) async {
    String url =
        "${serverUrl}mobileapp/apiRest/check?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "device_id": firebaseToken,
      "device_platform": platform,
      "app_version": version
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> saveProfile(String token, Profile profile) async {
    String url =
        "${serverUrl}mobileapp/apiRest/saveProfile?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "client_token": token,
      "full_name": profile.name,
      "contact_phone": profile.phone,
      "loc_name": profile.location.location,
      "country_code": profile.countryCode,
      "password": profile.password != null && profile.password != ""
          ? profile.password
          : "",
    };

    if (profile.avatar != null) {
      formData['file'] = await MultipartFile.fromFile(profile.avatar.path);
    } else {
      formData['file'] = "";
    }

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getNotificationList(String token, int page) async {
    String url =
        "${serverUrl}mobileapp/apinew/getNotificationList?json=true&api_key=flyereats&client_token=$token&page=$page";

    var responseJson;
    try {
      final response = await Dio().get(
        url,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("TOKEN", token);
    return true;
  }

  Future<String> getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("TOKEN");
    return token;
  }

  Future<bool> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemoved = await prefs.clear();
    return isRemoved;
  }

  Future<dynamic> getLocations(String countryId) async {
    String url =
        "http://flyereats.in/store/addressesWithCountry?country_id=$countryId";
    //String url = "${serverUrl}store/addressesWithCountry?country_id=$countryId";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getPredefinedLocationByLatLng(double lat, double lng) async {
    String url =
        "http://flyereats.in/mobileapp/apiRest/getPredefinedLocation?json=true&api_key=flyereats";
    //String url = "${serverUrl}mobileapp/apiRest/getPredefinedLocation?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "lat": lat.toString(),
      "long": lng.toString(),
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getRestaurantList(
      String token,
      String address,
      MerchantType merchantType,
      RestaurantListType type,
      String category,
      int page,
      bool isVegOnly,
      {String cuisineType,
      String sortBy,
      String searchKeyword}) async {
    String url =
        "${serverUrl}mobileapp/apiRest/restaurantList?json=true&api_key=flyereats";

    String merchantTypeParams;
    if (merchantType == MerchantType.restaurant) {
      merchantTypeParams = "food";
    } else if (merchantType == MerchantType.grocery) {
      merchantTypeParams = "grocery";
    } else if (merchantType == MerchantType.vegFruits) {
      merchantTypeParams = "fruits";
    } else if (merchantType == MerchantType.meat) {
      merchantTypeParams = "meat";
    }

    Map<String, dynamic> formData = {
      "client_token": token,
      "address": address,
      //"page": page.toString(),
      "merchant_type": merchantTypeParams,
      "is_veg": isVegOnly ? "1" : "0", //1 for true, 0 for false
    };

    if (type != null) {
      if (type == RestaurantListType.top) {
        formData['type'] = "sponsored";
      } else if (type == RestaurantListType.dbl) {
        formData['type'] = "time";
      } else if (type == RestaurantListType.orderAgain) {
        formData['type'] = "previous";
      }
    }

    if (sortBy != null) {
      formData['sortby'] = sortBy;
    }

    if (cuisineType != null) {
      formData['cuisinetype'] = cuisineType;
    }

    if (category != null) {
      formData['food_category_id'] = category;
    }

    if (searchKeyword != null) {
      formData['restaurant_name'] = searchKeyword;
    }

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getCategory(String restaurantId) async {
    String url =
        "${serverUrl}mobileapp/apinew/MenuCategory?json=true&merchant_id=$restaurantId&api_key=flyereats";
    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getOfferList(
      String token, String address, String type) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getOffers?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "address": address,
      "type": type, //type: {bank, admin, merchant}
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getActiveOrder(String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getActiveOrder?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getSimilarRestaurant(
      String token, String merchantId, String address) async {
    String url =
        "${serverUrl}mobileapp/apiRest/similarRestaurantList?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "merchant_id": merchantId,
      "address": address
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getWalletInfo(String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getWinAmount?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> addWallet(String token, double amount) async {
    String url =
        "${serverUrl}mobileapp/apiRest/addWalletMoney?json=true&api_key=flyereats";

    var formData = {"client_token": token, "amount": amount.toString()};

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getPickupInfo(String token, String address) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getPickupInfo?json=true&api_key=flyereats";

    var formData = {"client_token": token, "address": address};

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> globalSearch(
      String token, String textSearch, String address, int page) async {
    String url =
        "${serverUrl}mobileapp/apiRest/globalSearch?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "address": address,
      "search_text": textSearch,
      "page": page.toString(),
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getFoods(String restaurantId, String categoryId,
      bool isVegOnly, String searchKeyword, String address) async {
    String vegOnlyParam =
        isVegOnly != null ? isVegOnly ? "&is_veg=1" : "&is_veg=0" : "";
    String searchParam =
        searchKeyword != null ? "&searchitem=$searchKeyword" : "";
    String categoryParam = categoryId != null ? "&cat_id=$categoryId" : "";
    String addressParam = address != null ? "&address=$address" : "";
    String url =
        "${serverUrl}mobileapp/apiRest/getItem?json=true&api_key=flyereats&page=all&merchant_id=$restaurantId$categoryParam$vegOnlyParam$searchParam$addressParam";

    var responseJson;
    try {
      final response =
          await Dio().get(url, options: Options(contentType: 'JSON'));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> getFoodDetail(String foodId) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getItemDetails?json=true&api_key=flyereats";

    var formData = {
      "item_id": foodId,
    };

    var responseJson;
    try {
      final response = await Dio().post(url,
          data: FormData.fromMap(formData),
          options: Options(contentType: 'JSON'));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(var response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        responseJson = json.decode(response.data);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException('Error Communicating with server');
    }
  }
}
