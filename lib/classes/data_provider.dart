import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'package:flyereats/model/place_order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider {
  static String emailKey = "EMAIL";
  static String passwordKey = "PASSWORD";

  var client = http.Client();

  String developmentServerUrl = "https://www.pollachiarea.com/flyereats/";
  String productionServerUrl = "http://flyereats.in/";

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
        "${productionServerUrl}mobileapp/apinew/getPaymentOptions?json=true&$paramsUrl";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getPromos(String restaurantId, String token) async {
    String url =
        "${productionServerUrl}mobileapp/apinew/loadPromos?json=true&merchant_id=$restaurantId"
        "&api_key=flyereats&client_token=$token";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> applyCoupon(String restaurantId, String voucherCode,
      double totalOrder, String token) async {
    String url = "${productionServerUrl}mobileapp/apinew/applyVoucher?json=true"
        "&merchant_id=$restaurantId&voucher_code=$voucherCode"
        "&cart_sub_total=$totalOrder&api_key=flyereats&client_token=$token";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> loginWithEmail(String email, String password) async {
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
  }

  Future<bool> saveLoginInformation(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(emailKey, email);
    prefs.setString(passwordKey, password);
    return true;
  }

  Future<Map<String, String>> getLoginInformation() async {
    Map<String, String> map = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    map['email'] = prefs.getString(emailKey);
    map['password'] = prefs.getString(passwordKey);
    return map;
  }

  Future<dynamic> getLocations(String countryId) async {
    String url =
        "${productionServerUrl}store/addressesWithCountry?country_id=$countryId";

    var responseJson;
    try {
      final response = await client.get(url);
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
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getRestaurantList(String address, int page,
      {String cuisineType, String sortBy}) async {
    String addressUrl = Uri.encodeComponent(address);
    String cuisineTypeParam =
        cuisineType != null ? "&cuisine_type=$cuisineType" : "";
    String sortByParam = sortBy != null ? "&sortby=$sortBy" : "";
    String url =
        "${productionServerUrl}mobileapp/apinew/search?json=true&cusinetype=food&page=$page&isgetoffer=1&address=$addressUrl&api_key=flyereats$cuisineTypeParam$sortByParam";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getRestaurantTop(String address) async {
    String addressUrl = Uri.encodeComponent(address);
    String url =
        "${productionServerUrl}mobileapp/apinew/GetTopMerchentList?json=true&address=$addressUrl&api_key=flyereats";
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getCategory(String restaurantId) async {
    String url =
        "${productionServerUrl}mobileapp/apinew/MenuCategory?json=true&merchant_id=$restaurantId&api_key=flyereats";
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getFoods(String restaurantId, String categoryId) async {
    String url =
        "${productionServerUrl}mobileapp/apinew/getItem?json=true&api_key=flyereats&merchant_id=$restaurantId&cat_id=$categoryId";
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
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
