import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flyereats/classes/app_exceptions.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/model/address.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AddressDBProvider {
  var client = http.Client();
  String baseUrl = "http://flyereats.in/";

  AddressDBProvider._();

  static final AddressDBProvider db = AddressDBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "flyereats.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE address ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title VARCHAR(500),"
          "address TEXT,"
          "description TEXT,"
          "type VARCHAR(30),"
          "longitude TEXT,"
          "latitude TEXT,"
          "mapAddress TEXT"
          ")");
    });
  }

  addExampleAddress() async {
    final db = await database;
    for (int i = 0; i < ExampleModel.getAddresses().length; i++) {
      await db.rawInsert(
          "INSERT Into address (title, address, description, type, longitude, latitude, mapAddress)"
          " VALUES (?,?,?,?,?,?)",
          [
            ExampleModel.getAddresses()[i].title,
            ExampleModel.getAddresses()[i].address,
            ExampleModel.getAddresses()[i].address,
            ExampleModel.getAddresses()[i].type.toString(),
            ExampleModel.getAddresses()[i].longitude,
            ExampleModel.getAddresses()[i].latitude,
            ExampleModel.getAddresses()[i].mapAddress
          ]);
    }
  }

  Future<Address> getDefaultAddress() async {
    final db = await database;
    List<Map<String, dynamic>> addresses = await db.query("address");
    if (addresses.isEmpty) {
      return null;
    } else {
      return Address.fromMap(addresses[0]);
    }
  }

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
