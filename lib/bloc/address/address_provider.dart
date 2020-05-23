import 'dart:async';
import 'dart:io';

import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/model/address.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddressDBProvider {
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
          "latitude TEXT"
          ")");
    });
  }

  addExampleAddress() async {
    final db = await database;
    for (int i = 0; i < ExampleModel.getAddresses().length; i++) {
      await db.rawInsert(
          "INSERT Into address (title, address, description, type, longitude, latitude)"
          " VALUES (?,?,?,?,?,?)",
          [
            ExampleModel.getAddresses()[i].title,
            ExampleModel.getAddresses()[i].address,
            ExampleModel.getAddresses()[i].address,
            ExampleModel.getAddresses()[i].type.toString(),
            ExampleModel.getAddresses()[i].longitude,
            ExampleModel.getAddresses()[i].latitude
          ]);
    }
  }

  addAddress(Address address) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into address (title, address, description, type, longitude, latitude)"
        " VALUES (?,?,?,?,?,?)",
        [
          address.title,
          address.address,
          address.address,
          address.type.toString(),
          address.longitude,
          address.latitude
        ]);
    return raw;
  }

  updateAddress(Address address) async {
    final db = await database;
    var raw = await db.update('address', address.toMap(),
        where: 'id=?', whereArgs: [address.id]);
    return raw;
  }

  deleteAddress(int id) async {
    final db = await database;
    var raw = await db.delete('address', where: 'id=?', whereArgs: [id]);
    return raw;
  }

  Future<Address> getAddress(int id) async {
    final db = await database;
    List<Map<String, dynamic>> addresses =
        await db.query("address", where: "id = ?", whereArgs: [id]);
    return Address.fromMap(addresses[0]);
  }

  Future<Address> getDefaultAddress() async {
    final db = await database;
    List<Map<String, dynamic>> addresses = await db.query("address");
    if (addresses.isEmpty){
      return null;
    } else {
      return Address.fromMap(addresses[0]);
    }
  }

  Future<List<Address>> getAllAddress() async {
    final db = await database;
    List<Map<String, dynamic>> mapAddress =
        await db.query("address", orderBy: 'title');
    List<Address> listAddress = [];
    for (int i = 0; i < mapAddress.length; i++) {
      listAddress.add(Address.fromMap(mapAddress[i]));
    }

    return listAddress;
  }
}
