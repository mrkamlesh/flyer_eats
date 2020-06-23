import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flyereats/classes/app_exceptions.dart';
import 'package:flyereats/model/place_order.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flyereats/model/register_post.dart';

class DataProvider {
  static String emailKey = "EMAIL";
  static String passwordKey = "PASSWORD";

  String developmentServerUrl = "https://www.pollachiarea.com/flyereats/";
  String productionServerUrl = "http://flyereats.in/";

  Future<dynamic> checkPhoneExist(String contactPhone) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/checkMobileExist?json=true&api_key=flyereats";

    var formData = {
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

  Future<dynamic> register(RegisterPost registerPost) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/register?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "email_address": registerPost.email,
      "contact_phone": registerPost.contactPhone,
      "referral_code": registerPost.referral,
      "full_name": registerPost.name,
      "country_code": registerPost.countryId,
      "loc_name": registerPost.location,
      "device_id": registerPost.deviceId,
      "app_version": registerPost.appVersion,
      "device_platform": registerPost.devicePlatform,
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
        "${developmentServerUrl}mobileapp/apiRest/socialLogin?json=true&api_key=flyereats";

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
        "${developmentServerUrl}mobileapp/apiRest/checkEmailExist?json=true&api_key=flyereats";

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

  Future<dynamic> verifyOtp(String contactPhone, String otp) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/verifyOtp?json=true&api_key=flyereats";

    var formData = {
      "contact_phone": contactPhone,
      "code": otp,
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
        "${productionServerUrl}mobileapp/apinew/getCustomFields?json=true&api_key=flyereats";

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
    String paramsUrl = "next_step=payment_option&id=${order.address.id}"
        "&formatted_address=${order.address.address}"
        "&google_lat=${order.address.latitude}"
        "&google_lng=${order.address.longitude}"
        "&location_name=${order.address.title}"
        "&contact_phone=${order.contact}"
        "&delivery_instruction=${order.deliveryInstruction}"
        "&address_id=${order.address.id}"
        "&cart_subtotal=${order.subTotal()}"
        "&merchant_id=${order.restaurant.id}"
        "&client_token=${order.user.token}"
        "&transaction_type=${order.transactionType}"
        "&cart=${order.cartToString()}"
        "&api_key=flyereats"
/*        "&shipstreet_latlong="
        "&searchshipaddress="
        "&shipaddressselected="
        "&addrsub_lat=10.6619719"
        "&addrsub_lng=77.0078637"
        "&street=Pollachi Bus Stand, Palakkad-Pollachi Rd, Pollachi, Tamil Nadu, India"
        "&city=Pollachi"
        "&state=Tamilnadu&zipcode=642002"
        "&contact_phone=+919688322332"
        "&street=Pollachi Bus Stand, Palakkad-Pollachi Rd, Pollachi, Tamil Nadu, India"
        "&city=Pollachi"
        "&state=Tamilnadu"
        "&zipcode=642002"
        "&location_name=G"
        "&save_address=2"
        "&contact_phone=+919688322332"
        "&google_lat=10.662025792166915"
        "&google_lng=77.00790369623213"
        "&addrsub_lat=10.6619719"
        "&addrsub_lng=77.0078637"
        "&lang_id=en"
        "&lang=en"
        "&app_version=4.0.1"
        "&device_id=f3HrzBaFgJ4:APA91bHHMPLgAKBBkrgvu0imCQuGET7gehNQHtzqWM3G4kaUQRZV4UgrEBRBq805-nniR0eDZS0SMTt7j36kuNhgnrTWW3kYadHxotBcpTdRfWCEt9OlP45GjedIUB0bxRGNFf2V55vt"
        "&device_platform=Android"
        "&client_token=3khrihr4isa0fq4b88bd85385b989358685ce1b927d1339"
        "&client_state_city=Tamilnadu/Pollachi"*/
        ;

    String url =
        "${developmentServerUrl}mobileapp/apinew/getPaymentOptions?json=true&$paramsUrl";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> placeOrder(PlaceOrder order) async {
    String paramsUrl = "merchant_id=${order.restaurant.id}"
        "&client_token=${order.user.token}"
        "&transaction_type=${order.transactionType}"
        "&cart=${order.cartToString()}"
        "&formatted_address=${order.address.address}"
        "&google_lat=${order.address.latitude}"
        "&google_lng=${order.address.longitude}"
        "&voucher_code=${order.voucher.name}"
        "&next_step=payment_option"
        "&id=${order.address.id}"
        "&location_name=${order.address.title}"
        "&contact_phone=${order.contact}"
        "&delivery_instruction=${order.deliveryInstruction}"
        "&street=${order.address.address}"
        "&payment_list=${order.paymentList}"
        "&voucher_amount=${order.voucher.amount}"
        "&voucher_type=${order.voucher.type}"
        "&api_key=flyereats"
        "&earned_points=null"
        "&paypal_flag=2"
        "&paypal_mode="
        "&client_id_sandbox="
        "&client_id_live="
        "&client_id="
        "&paypal_card_fee="
        "&pts_redeem_points="
        "&pts_redeem_amount="

/*        "&delivery_date=2020-06-09"
        "&delivery_time=10:44 PM"
        "&delivery_asap="
        "&formatted_address=25/2c, Annaji Rao Rd, Mettupalayam Mettupalayam Tamilnadu 641301"
        "&google_lat=11.308392677645749"
        "&google_lng=76.93527662096479"
        "&addrsub_lat=11.304615"
        "&addrsub_lng=76.938307"
        "&shipstreet_latlong="
        "&searchshipaddress="
        "&shipaddressselected="
        "&state=Tamilnadu"
        "&zipcode=641301"
        "&search_address=Mettupalayam, Tamilnadu, India"
        "&device_id=f3HrzBaFgJ4:APA91bHHMPLgAKBBkrgvu0imCQuGET7gehNQHtzqWM3G4kaUQRZV4UgrEBRBq805-nniR0eDZS0SMTt7j36kuNhgnrTWW3kYadHxotBcpTdRfWCEt9OlP45GjedIUB0bxRGNFf2V55vt"
        "&cod_change_required="
        "&order_change="
        "&redeem_points="
        "&tips_percentage=0"
        "&json=true"
        "&lang_id=en"
        "&lang=en"
        "&app_version=4.0.1"
        "&device_id=f3HrzBaFgJ4:APA91bHHMPLgAKBBkrgvu0imCQuGET7gehNQHtzqWM3G4kaUQRZV4UgrEBRBq805-nniR0eDZS0SMTt7j36kuNhgnrTWW3kYadHxotBcpTdRfWCEt9OlP45GjedIUB0bxRGNFf2V55vt"
        "&device_platform=Android"
        "&client_state_city=Tamilnadu/Mettupalayam"*/
        ;

    String url =
        "${developmentServerUrl}mobileapp/apinew/placeOrder?json=true&$paramsUrl";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getOrderDetail(String orderId, String token) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/getReceipt?json=true&api_key=flyereats";

    var formData = {
      "client_token": token,
      "order_id": orderId,
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

  Future<dynamic> getPromos(String restaurantId, String token) async {
    String url =
        "${developmentServerUrl}mobileapp/apinew/loadPromos?json=true&merchant_id=$restaurantId"
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

  Future<dynamic> getOrderHistory(String token) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/getOrderHistory?json=true&api_key=flyereats";

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

  Future<dynamic> getHomePageData(
      {String token,
      String address,
      double lat,
      double long,
      int topRestaurantPage,
      int dblPage,
      int foodCategoryPage,
      int adsPage}) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/homePage?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "client_token": token,
      "sponsor_page": topRestaurantPage.toString(),
      "time_page": dblPage.toString(),
      "category_page": foodCategoryPage.toString(),
      "ads_page": adsPage.toString()
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
    String url =
        "${productionServerUrl}mobileapp/apinew/merchantReviews?json=true"
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
        "${developmentServerUrl}mobileapp/apinew/applyVoucher?json=true"
        "&merchant_id=$restaurantId&voucher_code=$voucherCode"
        "&cart_sub_total=$totalOrder&api_key=flyereats&client_token=$token";

    var responseJson;
    try {
      final response = await Dio().get(url);
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

  Future<dynamic> checkTokenValid(String token) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/check?json=true&api_key=flyereats";

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

  Future<dynamic> getLocations(String countryId) async {
    String url =
        "${productionServerUrl}store/addressesWithCountry?country_id=$countryId";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getLocationByLatLng(double lat, double lng) async {
    String url =
        "${productionServerUrl}mobileapp/apinew/search?json=true&isgetoffer=1&lat=$lat&lng=$lng&searchin=db&api_key=flyereats";

    var responseJson;
    try {
      final response = await Dio().get(url);
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
      {String cuisineType,
      String sortBy}) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/restaurantList?json=true&api_key=flyereats";

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
      "page": page.toString(),
      "merchant_type": merchantTypeParams,
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
        "${developmentServerUrl}mobileapp/apinew/MenuCategory?json=true&merchant_id=$restaurantId&api_key=flyereats";
    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getFoods(String restaurantId, String categoryId) async {
    String url =
        "${developmentServerUrl}mobileapp/apiRest/getItem?json=true&api_key=flyereats&merchant_id=$restaurantId&cat_id=$categoryId&page=all";

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
