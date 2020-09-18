import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:clients/classes/app_exceptions.dart';
import 'package:clients/model/address.dart';

class AddressProvider {
  //String serverUrl = "https://www.pollachiarea.com/flyereats/";
  String serverUrl = "http://flyereats.in/";

  Future<dynamic> deleteAddress(String id, String token) async {
    String url =
        "${serverUrl}mobileapp/apinew/deleteAddressBook?json=true&&client_token=$token&id=$id&lang_id=en&lang=en&api_key=flyereats";

    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on DioError {
      throw AppException(
          'Connection Lost!. Please check your internet connection', '');
    }
    return responseJson;
  }

  Future<dynamic> addAddress(Address address, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";

    /* String url =
        "https://www.pollachiarea.com/flyereats/mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";*/

    var formData = {
      "client_token": token,
      "street": address.address,
      "city": address.city,
      "state": address.state,
      "zipcode": address.zipCode,
      "location_name": address.title,
      "as_default": address.isDefault ? "2" : "1", //1 not default, 2 default
      "action": "add",
      "latitude": address.latitude,
      "longitude": address.longitude,
      "type": address.getType()
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on DioError {
      throw AppException(
          'Connection Lost!. Please check your internet connection', '');
    }

    return responseJson;
  }

  Future<dynamic> updateAddress(Address address, String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";

/*     String url =
        "https://www.pollachiarea.com/flyereats/mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";*/

    var formData = {
      "client_token": token,
      "street": address.address,
      "city": address.city,
      "state": address.state,
      "zipcode": address.zipCode,
      "location_name": address.title,
      "as_default": address.isDefault ? "2" : "1", //1 not default, 2 default
      "action": "update",
      "id": address.id,
      "latitude": address.latitude,
      "longitude": address.longitude,
      "type": address.getType()
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );
      responseJson = _returnResponse(response);
    } on DioError {
      throw AppException(
          'Connection Lost!. Please check your internet connection', '');
    }
    return responseJson;
  }

  Future<dynamic> getAddress(String id, String token) async {
    String url =
        "${serverUrl}mobileapp/apinew/getAddressBookDetails?json=true&client_token=$token&id=$id&lang_id=en&lang=en&api_key=flyereats";
    var responseJson;
    try {
      final response = await Dio().get(url);
      responseJson = _returnResponse(response);
    } on DioError {
      throw AppException(
          'Connection Lost!. Please check your internet connection', '');
    }
    return responseJson;
  }

  Future<dynamic> getAllAddress(String token) async {
    String url =
        "${serverUrl}mobileapp/apiRest/getAddressBook?json=true&api_key=flyereats";

    Map<String, dynamic> formData = {
      "client_token": token,
    };

    var responseJson;
    try {
      final response = await Dio().post(
        url,
        data: FormData.fromMap(formData),
      );

      responseJson = _returnResponse(response);
    } on DioError {
      throw AppException(
          'Connection Lost!. Please check your internet connection', '');
    }

    return responseJson;
  }

  dynamic _returnResponse(var response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        try {
          responseJson = json.decode(response.data);
        } catch (e) {
          throw AppException(
              "Something went wrong. Please try again later", "");
        }
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
