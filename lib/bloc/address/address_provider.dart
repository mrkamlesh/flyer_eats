import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'package:flyereats/model/address.dart';
import 'package:http/http.dart' as http;

class AddressProvider {
  var client = http.Client();

  /*String baseUrl = "http://flyereats.in/";*/
  String baseUrl = "https://www.pollachiarea.com/flyereats/";

  Future<dynamic> deleteAddress(String id, String token) async {
    String url =
        "${baseUrl}mobileapp/apinew/deleteAddressBook?json=true&&client_token=$token&id=$id&lang_id=en&lang=en&api_key=flyereats";

    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> addAddress(Address address, String token) async {
    String url =
        "${baseUrl}mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";

    /* String url =
        "https://www.pollachiarea.com/flyereats/mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";*/

    var formData = {
      "client_token": token,
      "street": address.address,
      "city": address.city,
      "state": address.state,
      "zipcode": address.zipCode,
      "location_name": address.title,
      "as_default": "1", //1 not default, 2 default
      "action": "add",
      "latitude": address.latitude,
      "longitude": address.longitude,
      "type": address.getType()
    };

    var responseJson;
    try {
      final response = await http.post(
        url,
        body: formData,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  Future<dynamic> updateAddress(Address address, String token) async {
    String url =
        "${baseUrl}mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";

/*     String url =
        "https://www.pollachiarea.com/flyereats/mobileapp/apiRest/saveAddressBook?json=true&api_key=flyereats";*/

    var formData = {
      "client_token": token,
      "street": address.address,
      "city": address.city,
      "state": address.state,
      "zipcode": address.zipCode,
      "location_name": address.title,
      "as_default": "1", //1 not default, 2 default
      "action": "update",
      "id": address.id,
      "latitude": address.latitude,
      "longitude": address.longitude,
      "type": address.getType()
    };

    var responseJson;
    try {
      final response = await http.post(
        url,
        body: formData,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAddress(String id, String token) async {
    String url =
        "${baseUrl}mobileapp/apinew/getAddressBookDetails?json=true&client_token=$token&id=$id&lang_id=en&lang=en&api_key=flyereats";
    var responseJson;
    try {
      final response = await client.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAllAddress(String token) async {
    String url =
        "${baseUrl}mobileapp/apinew/getAddressBook?json=true&client_token=$token&json=true&lang_id=en&lang=en&api_key=flyereats";
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
