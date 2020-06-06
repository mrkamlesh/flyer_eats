import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {
  var client = http.Client();

  String developmentServerUrl = "https://www.pollachiarea.com/flyereats/";
  String productionServerUrl = "http://flyereats.in/";

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
