import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {
  var client = http.Client();

  String baseUrl = "https://www.pollachiarea.com/flyereats/";
  String baseUrl2 = "http://flyereats.in/";

  Future<dynamic> getLocations(String countryId) async {
    String url = "${baseUrl}store/addressesWithCountry?country_id=$countryId";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getRestaurantList(String address) async {
    String addressUrl = Uri.encodeComponent(address);
    String url =
        "${baseUrl}mobileapp/apinew/search?json=true&sortby=is_open&cusinetype=food&page=1&isgetoffer=1&address=$addressUrl&api_key=flyereats";

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
        "${baseUrl}mobileapp/apinew/GetTopMerchentList?json=true&address=$addressUrl&api_key=flyereats";
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
        "${baseUrl}mobileapp/apinew/MenuCategory?json=true&merchant_id=$restaurantId&api_key=flyereats";
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
        "${baseUrl2}mobileapp/apinew/getItem?json=true&api_key=flyereats&merchant_id=$restaurantId&cat_id=$categoryId";
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
      default:
        throw FetchDataException('Error Communicating with server');
    }
  }
}
