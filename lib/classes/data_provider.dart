import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {

  Future<dynamic> getLocations(double lat, double long) async {
    String url = "http://flyereats.in/store/getaddress?lat=$lat&lng=$long";

    var responseJson;
    try {
      final response = await http.get(url);
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
